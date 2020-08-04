import 'dart:async';
import 'package:note_app/model/reminder_model.dart';
import 'package:note_app/helperclass/reminder_database_helper_class.dart';

class ReminderBloc {


  ReminderBloc() {
    getScheduledReminders();
    getFiredReminders();
    getCancelledReminders();
    updateAllNo();
    updateScheduledNo();
    updateFiredNo();
    updateCancelledNo();
  }


  //Data streams
  final _scheduledReminderController =
      StreamController<List<Reminder>>.broadcast();
  get scheduledReminder => _scheduledReminderController.stream;

  final _firedReminderController = StreamController<List<Reminder>>.broadcast();
  get firedReminder => _firedReminderController.stream;

  final _cancelledReminderController=StreamController<List<Reminder>>.broadcast();
  get cancelledReminder=>_cancelledReminderController.stream;


  //length of reminders
  final _scheduledController=StreamController<int>.broadcast();
  get scheduledNo=>_scheduledController.stream;
  Function(int) get changeScheduled => _scheduledController.sink.add;

  final _firedController=StreamController<int>.broadcast();
  get firedNo=>_firedController.stream;
  Function(int) get changeFired => _firedController.sink.add;

  final _cancelledController=StreamController<int>.broadcast();
  get cancelledNo=>_cancelledController.stream;
  Function(int) get changeCancelled => _cancelledController.sink.add;

  final _allReminderController=StreamController<int>.broadcast();
  get allReminderNo=>_allReminderController.stream;
  Function(int) get changeAllReminder => _allReminderController.sink.add;

  updateFiredNo()async{
    changeFired(await DatabaseHelper.db.getNoOfReminders(0));
  }
  updateScheduledNo()async{
    changeScheduled(await DatabaseHelper.db.getNoOfReminders(1));
  }
  updateCancelledNo()async{
    changeCancelled(await DatabaseHelper.db.getNoOfReminders(2));
  }
  updateAllNo()async{
    changeAllReminder(await DatabaseHelper.db.getAllReminders());
  }


//rest of blocs
  final List<Reminder> scheduledReminders = [];
  final  List<Reminder> firedReminders = [];
  final  List<Reminder> cancelledReminders = [];

  initScheduledReminders() async {
    scheduledReminders.clear();
    scheduledReminders
        .addAll(await DatabaseHelper.db.getAllScheduledReminders());
  }

  initFiredReminder() async {
    firedReminders.clear();
    firedReminders.addAll(await DatabaseHelper.db.getAllFiredReminders());
  }

  initCancelledReminder()async{
    cancelledReminders.clear();
    cancelledReminders.addAll(await DatabaseHelper.db.getAllCancelledReminders());
  }


  getScheduledReminders() async {
    _scheduledReminderController.sink.add(await DatabaseHelper.db.getAllScheduledReminders());
  }

  getFiredReminders() async {
    _firedReminderController.sink.add(await DatabaseHelper.db.getAllFiredReminders());
  }

  getCancelledReminders()async{
    _cancelledReminderController.sink.add(await DatabaseHelper.db.getAllCancelledReminders());
  }

  add(Reminder reminder) async {
   await  DatabaseHelper.db.addANewReminder(reminder);
    getScheduledReminders();
    updateScheduledNo();
    updateAllNo();
  }

  update(Reminder reminder) async {
    await DatabaseHelper.db.updateAReminder(reminder);
    getScheduledReminders();
    getCancelledReminders();
    updateCancelledNo();
    updateScheduledNo();
  }

  delete(int id) async {
    await DatabaseHelper.db.deleteAReminder(id);
    getScheduledReminders();
    getFiredReminders();
    getCancelledReminders();
    updateCancelledNo();
    updateFiredNo();
    updateScheduledNo();
    updateAllNo();
  }

  fired(Reminder reminder) async {
    await DatabaseHelper.db.changeToFired(reminder);
    getFiredReminders();
    getScheduledReminders();
    updateFiredNo();
    updateScheduledNo();
  }

  cancelled(Reminder reminder)async{
   await  DatabaseHelper.db.changeToCancelled(reminder);
    getScheduledReminders();
    getCancelledReminders();
    updateCancelledNo();
    updateScheduledNo();
  }

  test(){
    getScheduledReminders();
    getFiredReminders();
    getCancelledReminders();
    updateAllNo();
    updateScheduledNo();
    updateFiredNo();
    updateCancelledNo();
  }

  cancelAll(){
    DatabaseHelper.db.cancelAllReminders();
//    getCancelledReminders();
//    getScheduledReminders();
//    updateCancelledNo();
//    updateScheduledNo();
  }


  deleteAll(){
    DatabaseHelper.db.deleteAllReminders();
  }

  dispose() {
    _scheduledReminderController.close();
    _cancelledReminderController.close();
    _firedReminderController.close();
    _scheduledController.close();
    _cancelledController.close();
    _firedController.close();
    _allReminderController.close();
  }
}

final reminderBloc = ReminderBloc();
