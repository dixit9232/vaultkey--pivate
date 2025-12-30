/// Data layer barrel file
/// Export all data sources, models, and repositories
library;

// Datasources
export 'datasources/local/local_datasource.dart';
export 'datasources/local/authenticator_local_datasource.dart';
export 'datasources/remote/firebase_datasource.dart';
export 'datasources/remote/supabase_datasource.dart';

// Models
export 'models/user_model.dart';
export 'models/authenticator_model.dart';

// Repositories
export 'repositories/auth_repository_impl.dart';
export 'repositories/authenticator_repository_impl.dart';
