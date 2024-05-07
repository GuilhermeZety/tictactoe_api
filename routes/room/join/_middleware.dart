// ignore_for_file: lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';

import '../../../src/services/supabase_service.dart';

Handler middleware(Handler handler) => handler.use(provider<SupabaseClient>((_) => SupabaseService.client));
