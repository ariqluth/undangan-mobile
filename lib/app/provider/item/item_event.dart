// item_event.dart
import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../models/item.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class GetItems extends ItemEvent {
  @override
  List<Object> get props => [];
}

class CreateItem extends ItemEvent {
  final Item item;
  final File imageFile;

  const CreateItem(this.item, this.imageFile);

  @override
  List<Object> get props => [item, imageFile];
}

class UpdateItem extends ItemEvent {
  final int id;
  final Item item;
  final File? imageFile;

  const UpdateItem(this.id, this.item, [this.imageFile]);

  @override
  List<Object> get props => [id, item, if (imageFile != null) imageFile!];
}

class DeleteItem extends ItemEvent {
  final int id;

  const DeleteItem(this.id);

  @override
  List<Object> get props => [id];
}