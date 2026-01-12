# CI/CD Workflow Notes

## Current Workflow

The project uses Very Good Workflows for CI/CD. The workflow file `.github/workflows/main.yaml` defines:

1. **semantic-pull-request**: Validates PR titles
2. **build**: Runs Flutter package workflow (build, test, analyze)
3. **spell-check**: Checks markdown files for spelling errors

## Code Generation in CI

The Very Good Workflows `flutter_package.yml` typically includes:
- `flutter pub get`
- `flutter analyze`
- `flutter test`

However, this project requires **build_runner** to generate code files before building/testing.

## Recommended CI Enhancement

To ensure the auth feature works in CI, the build workflow should run code generation:

### Option 1: Update .github/workflows/main.yaml

Add a pre-build step:

```yaml
jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
          channel: 'stable'
      - name: Install dependencies
        run: flutter pub get
      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs
      - name: Upload generated files
        uses: actions/upload-artifact@v3
        with:
          name: generated-code
          path: |
            lib/**/*.g.dart
            lib/**/*.gr.dart
            lib/**/injection.config.dart

  build:
    needs: generate
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
    with:
      flutter_channel: stable
```

### Option 2: Use Melos Script

If the project uses melos for development, add a CI script in `melos.yaml`:

```yaml
scripts:
  ci-generate:
    description: Generate code for CI/CD
    exec: dart run build_runner build --delete-conflicting-outputs
    name: Generate Code
    packageFilters:
      scope: lucid_clip
```

Then in the workflow:

```yaml
- name: Setup Melos
  run: dart pub global activate melos
- name: Generate code
  run: melos run ci-generate
```

### Option 3: Pre-commit Hook

Add generated files to the repository (not recommended for large projects):

```bash
# Generate and commit generated files
dart run build_runner build --delete-conflicting-outputs
git add lib/**/*.g.dart lib/**/*.gr.dart lib/**/injection.config.dart
git commit -m "chore: update generated files"
```

## Current Situation

Since Flutter/Dart is not available in the current environment, the generated files are not present. When the PR is merged or CI runs, one of the following will happen:

1. **CI will fail** if it tries to build without running build_runner first
2. **CI will succeed** if Very Good Workflows includes build_runner execution
3. **Manual intervention needed** if neither of the above is true

## Recommendation

Before merging this PR, either:

1. **Run locally**: Execute `melos run generate-files` and commit the generated files
2. **Update CI**: Add code generation step to the workflow
3. **Check CI logs**: See if Very Good Workflows already handles this

## Generated Files Expected

After running build_runner, these files should be created:

```
lib/features/auth/data/models/user_model.g.dart
lib/core/routes/app_routes.gr.dart
lib/core/di/injection.config.dart
```

These files are required for the app to compile and run.

## Alternative: Commit Generated Files

If you want to avoid CI changes, you can commit generated files:

```bash
# Locally run:
dart run build_runner build --delete-conflicting-outputs

# Then commit:
git add lib/**/*.g.dart lib/**/*.gr.dart lib/**/injection.config.dart
git commit -m "chore: add generated files for auth feature"
git push
```

This ensures the code is immediately buildable, though it goes against some best practices of not committing generated code.

## Best Practice Recommendation

The cleanest approach:

1. Add code generation to CI pipeline
2. Don't commit generated files
3. Developers run `melos run generate-files` locally
4. CI runs the same command before build/test

This is the approach used by most Flutter projects with code generation.
