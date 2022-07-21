# Paginate

Customizable scroll pagination which lazily adds data, as the user scrolls down the screen, into a single immutable state and shares that with the builder.

## Features

- Lazily loads data
- Shares single immutable list of all data. You can apply sorting or filtering logic yourself in the data builder.
- You can use any widget for different situations such as when data is empty, loading, error, loading more, etc.
- PaginationDataController can be used to refresh your data loading.
- You can listen to events from PaginationDataController as streams.
- Build your own pagination widget with the PaginationDataController using your favorite state management.

## Getting started

## Usage

### Use this package as a library

#### Depend on it

Run this command:

With Flutter:
```sh

 $ flutter pub add paginate
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  paginate: ^0.0.1
```

#### Import it

Now in your Dart code, you can use:

```dart
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
```

## Additional information

This package is not yet stable and is experimental. The API may change later.
