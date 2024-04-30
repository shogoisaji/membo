import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_repository.g.dart';

@Riverpod(keepAlive: true)
SupabaseRepository supabaseRepository(SupabaseRepositoryRef ref) {
  return SupabaseRepository(Supabase.instance.client);
}

class SupabaseRepository {
  SupabaseRepository(this._client);

  final SupabaseClient _client;

//   Future<String?> insertReservation(Reservation reservation) async {
//     if (reservation.userId == null && reservation.userName == null && reservation.email == null) {
//       throw Exception('not login user & userName, email is null');
//     }
//     try {
//       final response = await _client.from('reservation').insert([
//         reservation.userId != null
//             ? {
//                 'reservation_date': reservation.reservationDate.toIso8601String(),
//                 'user_id': reservation.userId,
//               }
//             : {
//                 'reservation_date': reservation.reservationDate.toIso8601String(),
//                 'user_name': reservation.userName,
//                 'phone_number': reservation.phoneNumber,
//                 'email': reservation.email,
//               }
//       ]);
//       if (response != null) {
//         throw Exception('Insert error: ${response.error.message}');
//       }
//       print('success insert reservation');
//       return null;
//     } catch (err) {
//       // return ErrorHandler.handleError(err);
//     }
//     return null;
//   }

//   Future<Reservation?> getReservationById(int id) async {
//     try {
//       final response = await _client.from('reservation').select().eq('id', id).single();
//       print('get reservation by id: $response');
//       return Reservation.fromJson(response);
//     } catch (err) {
//       // final errorString = ErrorHandler.handleError(err);
//       return null;
//     }
//   }

//   Future<int> fetchNextReservationId() async {
//     try {
//       final response = await _client.from('reservation').select('id').order('id', ascending: false).limit(1);
//       return response[0]['id'] + 1;
//     } catch (err) {
//       // final errorString = ErrorHandler.handleError(err);
//       // if (err.toString().contains("XMLHttpRequest error.")) {
//       //   throw errorString;
//       // }
//       // throw errorString;
//     }
//   }

//   // Stream<List<Reservation>?> reservationListStream() {
//   //   return _client
//   //       .from('reservation')
//   //       .stream(primaryKey: ['id'])
//   //       .map((maps) => maps.map((map) => Reservation.fromJson(map)).toList())
//   //       .handleError((_) => []);
//   // }
//   Stream<List<Reservation>?> reservationListStream() {
//     final StreamController<List<Reservation>?> controller = StreamController();
//     _client.from('reservation').stream(primaryKey: ['id']).listen((maps) {
//       final reservations = maps.map((map) => Reservation.fromJson(map)).toList();
//       controller.add(reservations);
//     }).onError((error) {
//       controller.addError(error);
//     });

//     return controller.stream;
//   }

//   Future<List<Reservation>> getReservationListAll() async {
//     try {
//       final response = await _client.from('reservation').select();
//       final List<Reservation> reservationList = [];
//       for (final reservation in response) {
//         reservationList.add(Reservation.fromJson(reservation));
//       }
//       return reservationList;
//     } catch (err) {
//       // final errorString = ErrorHandler.handleError(err);
//       // if (err.toString().contains("XMLHttpRequest error.")) {
//       //   throw errorString;
//       // }
//       // throw errorString;
//     }
//   }

// // dateの予約を取得
//   // Future<List<Reservation>?> getReservationList(DateTime date) async {
//   //   try {
//   //     DateTime dateOnly = DateTime(date.year, date.month, date.day);
//   //     final List<Reservation> reservationList = [];
//   //     final response = await _client.from('reservation').select();
//   //     for (final reservation in response) {
//   //       final DateTime dbDate = DateTime.parse(reservation['reservation_date']);
//   //       final DateTime convertDate = DateTime(dbDate.year, dbDate.month, dbDate.day);
//   //       if (convertDate == dateOnly) {
//   //         reservationList.add(Reservation.fromJson(reservation));
//   //       }
//   //     }
//   //     return reservationList;
//   //   } catch (err) {
//   //     throw err.toString();
//   //   }
//   // }

//   Future<String?> deleteReservationDate(int id) async {
//     try {
//       final response = await _client.from('reservation').upsert({'reservation_date': ''});

//       print('success delete reservation date : $response');
//       return null;
//     } catch (err) {
//       // return ErrorHandler.handleError(err);
//     }
//     return null;
//   }
}
