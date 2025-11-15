import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:simple_note/core/network/model/api_response.dart';
import 'package:simple_note/features/notes/data/models/network_note_model.dart';

part 'notes_api_service.g.dart';

@RestApi(baseUrl: '/notes')
abstract class NotesApiService {
  factory NotesApiService(Dio dio, {String baseUrl}) = _NotesApiService;

  @GET('')
  Future<ApiResponse<List<NetworkNoteModel>>> getNotes();

  @GET('/{id}')
  Future<ApiResponse<NetworkNoteModel>> getNoteById(@Path('id') int id);

  @POST('')
  Future<ApiResponse<NetworkNoteModel>> createNote(
    @Body() Map<String, dynamic> note,
  );

  @PUT('/{id}')
  Future<ApiResponse<NetworkNoteModel>> updateNote(
    @Path('id') int id,
    @Body() Map<String, dynamic> note,
  );

  @DELETE('/{id}')
  Future<ApiResponse<void>> deleteNote(@Path('id') int id);
}
