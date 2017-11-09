/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdl_forms_sample.dialog;

@Component
class TimeFrameDialog extends MaterialDialog {
    final Logger _logger = new Logger('mobiad_rest_ui_mdl.dialogs.TimeFrameDialog');

    /// Zeigt den SetTimeFrameDialog an
    ///
    /// Wenn [undoPossible] auf true gesetzt ist kann der User
    /// den Dialog beenden und kehrt zu seinem vorhergehenden Login zurück
    /// [undoPossible] wird eingeschaltet wenn der User eingeloggt ist
    TimeFrameDialog({final bool undoPossible: false })
        : super(new DialogConfig(
            closeOnBackDropClick: undoPossible,
            acceptEscToClose: undoPossible)
    );

    @override
    Future<MdlDialogStatus> show(
        { final Duration timeout, Future onDialogInit(final String dialogId)}) {
        return super.show(onDialogInit: _init);
    }

    DateTime get from => new DateTime(fromDate.value.year,fromDate.value.month,fromDate.value.day,
        fromTime.value.hour,fromTime.value.minute);

    DateTime get to => new DateTime(toDate.value.year,toDate.value.month,toDate.value.day,
        toTime.value.hour,toTime.value.minute);

    void set from(final DateTime date) {
        fromDate.value = new DateTime(date.year,date.month,date.day,
            date.hour,date.minute);

        fromTime.value = new DateTime(date.year,date.month,date.day,
            date.hour,date.minute);
    }

    void set to(final DateTime date) {
        toDate.value = new DateTime(date.year,date.month,date.day,
            date.hour,date.minute);

        toTime.value = new DateTime(date.year,date.month,date.day,
            date.hour,date.minute);
    }

    // - FormFields --------------------------------------------------------------------------------

    final fromDate = new ObservableProperty<DateTime>(new DateTime.now(),
        observeViaTimer: false,formatter: _dateFormatter);

    final fromTime = new ObservableProperty<DateTime>(new DateTime.now(),
        observeViaTimer: false,formatter: _timeFormatter);

    final toDate = new ObservableProperty<DateTime>(new DateTime.now().add(new Duration(hours: 24)),
        observeViaTimer: false,formatter: _dateFormatter);

    final toTime = new ObservableProperty<DateTime>(new DateTime.now().add(new Duration(hours: 24)),
        observeViaTimer: false,formatter: _timeFormatter);

    // - EventHandler -----------------------------------------------------------------------------

    void onOK(final dom.Event event) {
        event.preventDefault();
        close(MdlDialogStatus.OK);
    }

    void onCancel(final dom.Event event) {
        event.preventDefault();
        close(MdlDialogStatus.CANCEL);
    }

    void onClear(final dom.Event event) {
        event.preventDefault();
        _allFields.forEach((final ObservableProperty property) => property..reset()..update());
        _form.update();
    }

    void onStartDate(final dom.Event event) {
        event.preventDefault();

        final MaterialDatePicker datePicker = new MaterialDatePicker();
        datePicker.dateTime = fromDate?.value ?? new DateTime.now();
        datePicker.show().then((final MdlDialogStatus status) {
            if(status == MdlDialogStatus.OK) {
                fromDate.value = datePicker.dateTime;
            }
        });
    }

    void onStartTime(final dom.Event event) {
        event.preventDefault();

        final MaterialTimePicker timePicker = new MaterialTimePicker();
        timePicker.dateTime = fromTime?.value ?? new DateTime.now();
        timePicker.show().then((final MdlDialogStatus status) {
            if(status == MdlDialogStatus.OK) {
                fromTime.value = timePicker.dateTime;
            }
        });
    }

    void onEndDate(final dom.Event event) {
        event.preventDefault();

//        final MaterialDatePicker datePicker = new MaterialDatePicker();
//        datePicker.dateTime = toDate?.value ?? new DateTime.now();
//        datePicker.show().then((final MdlDialogStatus status) {
//            if(status == MdlDialogStatus.OK) {
//                toDate.value = datePicker.dateTime;
//            }
//        });
    }

    void onEndTime(final dom.Event event) {
        event.preventDefault();

//        final MaterialTimePicker timePicker = new MaterialTimePicker();
//        timePicker.dateTime = toTime?.value ?? new DateTime.now();
//        timePicker.show().then((final MdlDialogStatus status) {
//            if(status == MdlDialogStatus.OK) {
//                toTime.value = timePicker.dateTime;
//            }
//        });
    }

    // - private ----------------------------------------------------------------------------------
    MaterialFormComponent get _form => MaterialFormComponent.widget(query(".mdl-form"));

    static String _dateFormatter(final DateTime date, final baseValue,
        { final String format: "dd.MM.yyyy"})
        => date != null ? new DateFormat(format).format(date) : (baseValue?.toString() ?? "");

    static String _timeFormatter(final DateTime date, final baseValue,
        { final String format: "HH:mm"})
        => date != null ? new DateFormat(format).format(date) : (baseValue?.toString() ?? "");

    Future _init(final String dialogID) async {
        _form.isFormValidCallback = _isFormValid;
        _bindObservable();
    }

    List<ObservableProperty> get _allFields => <ObservableProperty> [
        fromDate, fromTime, toDate, toTime
    ];

    void _bindObservable() {
        _allFields.forEach((final ObservableProperty property) {
            property
                ..onReset(() => null)

                // Wenn der property-value von einem String in ein Datum
                // konvertiert werden soll (InputFeld -> Datum)
                //
                // Der _TextFieldObserver (ModelObserver.dart) setzt den textfield.value
                // Der ModelObserver verwendet dazu "ObservableProperty#toString" #toString
                // verwendet seinerseits den Formatter (aus ObservableProperty)
                // this#_dateFormatter und this#_timeFormatter
                // Diese Formatter ändern null values zu leeren Strings
                ..onStaticCast(_toDateTime)
            ;
        });
    }

    /// Konvertiert den String des Input-Feldes in ein Datum oder eine Zeit
    DateTime _toDateTime(final value) {
        final RegExp reDate = new RegExp(r"^(\d\d)\.(\d\d)\.(\d{4})$");
        final RegExp reTime = new RegExp(r"^(\d\d):(\d\d)$");

        Match match = reDate.firstMatch(value.toString().trim());
        if(match != null) {
            return new DateTime(
                int.parse(match[3]),int.parse(match[2]),int.parse(match[1]));
        }
        match = reTime.firstMatch(value.toString().trim());
        if(match != null) {
            return new DateTime(
                new DateTime.now().year,1,1,
                int.parse(match[1]),int.parse(match[2]));
        }

        return null;
    }

    /// Checkt ob alle Felder ein gültiges Datum haben und
    /// ob das End-Datum größer ist als das Startdatum
    bool _isFormValid(final MaterialFormState state) {
        if(state == MaterialFormState.INVALID) {
            _logger.warning("Original form state is invalid");
            return false;
        }

        // Ist eines der Felder auf null?
        if(_allFields.where((final ObservableProperty field) => field.value == null).isNotEmpty) {
            _logger.warning("Form-Field is null! (Invalid date format)");
            return false;
        }
        
        final isBefore = from.isBefore(to);
        if(!isBefore) {
            _logger.warning("Start-Date ($from) > End-Date ($to)!");
        }
        return isBefore;
    }

    // - template ----------------------------------------------------------------------------------

    @override
    String template = """
    <div class="mdl-dialog set-timeframe-dialog">
    <form method="post" class="right mdl-form">
        <h5 class="mdl-form__title" translate='yes'>_('Timeframe')</h5>
        <div class="mdl-form__content">
            <!-- Timeframe start -->
            <div class="mdl-form__group">
                <div class="mdl-labelfield">
                    <label class="mdl-labelfield__label" 
                        translate='yes'>_('Begin:')</label>
                </div>
                <div class="mdl-textfield">
                    <!-- HTML5-Pattern: http://html5pattern.com/Dates -->
                    <input class="mdl-textfield__input" type="text" id="timeframe_start_date"
                           required pattern="(0[1-9]|1[0-9]|2[0-9]|3[01]).(0[1-9]|1[012]).[0-9]{4}"
                           mdl-model='fromDate' data-mdl-click="onStartDate(\$event)">
                    <label class="mdl-textfield__label mdl-textfield__label--icon-right"
                           for="timeframe_start_date">DD.MM.YYYY
                        <i class="material-icons">event</i>
                    </label>
                </div>

                <div class="mdl-textfield">
                    <!--
                    Pattern: https://stackoverflow.com/questions/14772142/24-hour-time-regex-for-html-5
                        http://www.mkyong.com/regular-expressions/how-to-validate-time-in-24-hours-format-with-regular-expression/
                    -->
                    <input class="mdl-textfield__input" type="text" id="timeframe_start_time"
                           required pattern="([01]?[0-9]{1}|2[0-3]{1}):[0-5]{1}[0-9]{1}"
                           mdl-model='fromTime' data-mdl-click="onStartTime(\$event)">
                    <label class="mdl-textfield__label mdl-textfield__label--icon-right"
                           for="timeframe_start_time">HH:MM
                        <i class="material-icons">schedule</i>
                    </label>
                </div>
            </div>

            <!-- Timeframe end -->
            <div class="mdl-form__group">
                <div class="mdl-labelfield">
                    <label class="mdl-labelfield__label" 
                        translate='yes'>_('End:')</label>
                </div>
                <div class="mdl-textfield">
                    <!-- HTML5-Pattern: http://html5pattern.com/Dates -->
                    <input class="mdl-textfield__input" type="text" id="timeframe_end_date"
                           required pattern="(0[1-9]|1[0-9]|2[0-9]|3[01]).(0[1-9]|1[012]).[0-9]{4}"
                           mdl-model='toDate' data-mdl-click="onEndDate(\$event)">
                    <label class="mdl-textfield__label mdl-textfield__label--icon-right"
                           for="timeframe_end_date">
                        DD.MM.YYYY
                        <i class="material-icons">event</i>
                    </label>
                </div>

                <div class="mdl-textfield">
                    <!--
                    Pattern: https://stackoverflow.com/questions/14772142/24-hour-time-regex-for-html-5
                        http://www.mkyong.com/regular-expressions/how-to-validate-time-in-24-hours-format-with-regular-expression/
                    -->
                    <input class="mdl-textfield__input" type="text" id="timeframe_end_time"
                           required pattern="([01]?[0-9]{1}|2[0-3]{1}):[0-5]{1}[0-9]{1}"
                           mdl-model='toTime' data-mdl-click="onEndTime(\$event)">
                    <label class="mdl-textfield__label mdl-textfield__label--icon-right"
                           for="timeframe_end_time">
                        HH:MM
                        <i class="material-icons">schedule</i>
                    </label>
                </div>
            </div>
            <p translate='yes'>_('Form checks if "Begin" is before "End"')</p>
        </div>
        <div class="mdl-form__actions">
            <button class="mdl-button"
                    data-mdl-click="onClear(\$event)" translate='yes'>_('Clear')</button>

            <span class='mdl-form__actions__spacer'></span>
                                
            <button class="mdl-button"
                    data-mdl-click="onCancel(\$event)" 
                    translate='yes'>_('Cancel')</button>
                    
            <button class="mdl-button mdl-button--submit mdl-button--primary"
                    data-mdl-click="onOK(\$event)" 
                    translate='yes' disabled>_('OK')</button>
        </div>
    </form>
    </div>""";
}