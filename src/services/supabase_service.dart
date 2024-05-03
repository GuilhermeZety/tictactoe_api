// ignore_for_file: lines_longer_than_80_chars

import 'package:dotenv/dotenv.dart';
import 'package:supabase/supabase.dart';

class SupabaseService {
  static SupabaseClient get client {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    return SupabaseClient(
      env['SUPABASE_URL']!,
      env['SUPABASE_KEY']!,
    );
  }
}
