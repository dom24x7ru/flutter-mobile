import 'package:dom24x7_flutter/models/instruction/instruction.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'instructions.g.dart';

class InstructionsStore = _InstructionsStore with _$InstructionsStore;

abstract class _InstructionsStore with Store {
  @observable
  List<Instruction>? list;

  @action
  void addInstruction(Instruction instruction) {
    list = Utilities.addOrReplaceById(list, instruction);
  }

  @action
  void setInstructions(List<Instruction> instructions) {
    list = instructions;
  }

  @action
  void clear() {
    list = null;
  }
}