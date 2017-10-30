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

library mdl_dialog_sample.customdialog2;

import 'dart:async';
import 'dart:html' as dom;

import 'package:intl/intl.dart';
import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

import 'package:dice/dice.dart' as di;

@di.injectable
class CustomDialog2 extends MaterialDialog {

    static const String _DEFAULT_SUBMIT_BUTTON = "Submit";
    static const String _DEFAULT_CANCEL_BUTTON = "Cancel";

    String title = "";
    String yesButton = _DEFAULT_SUBMIT_BUTTON;
    String noButton = _DEFAULT_CANCEL_BUTTON;

    final ObservableProperty<String> name = new ObservableProperty<String>('',name: "Name");

    CustomDialog2() : super(new DialogConfig());

    CustomDialog2 call({ final String title: "",
                         final String yesButton: _DEFAULT_SUBMIT_BUTTON,
                         final String noButton: _DEFAULT_CANCEL_BUTTON }) {

        this.title = title;
        this.yesButton = yesButton;
        this.noButton = noButton;

        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onSubmit() {
        close(MdlDialogStatus.OK);
    }

    void onCancel() {
        close(MdlDialogStatus.CANCEL);
    }

    Future onClickDate(final dom.Event event) async {
        event.preventDefault();
        final MaterialDatePicker datePicker = new MaterialDatePicker();

        final MdlDialogStatus status = await datePicker.show();
        if(status == MdlDialogStatus.OK) {
            _startDate.value = new DateFormat("dd.MM.yyyy").format(datePicker.dateTime);

        }
    }
    
    // - private ----------------------------------------------------------------------------------

    MaterialTextfield get _startDate => MaterialTextfield.widget(dialog.querySelector("#start_date"));

    // - template ----------------------------------------------------------------------------------

    @override
    String template = """
        <div class="mdl-dialog custom-dialog2">
          <div class="mdl-dialog__content">
            {{#hasTitle}}<h5 class="mdl-color-text--primary-dark">{{title}}</h5>{{/hasTitle}}
            <div class="mdl-textfield mdl-textfield--floating-label">
                  <input class="mdl-textfield__input" type="text" id="name" mdl-model="name" autofocus>
                  <label class="mdl-textfield__label" for="name">Name</label>
            </div>
            <div class="mdl-textfield mdl-textfield--floating-label">
                  <input class="mdl-textfield__input" type="text" id="address" >
                  <label class="mdl-textfield__label" for="address">Address</label>
            </div>
            <div class="mdl-textfield" 
                       data-mdl-click='onClickDate(\$event)'>
                <!-- HTML5-Pattern: http://html5pattern.com/Dates -->
                <input class="mdl-textfield__input" type="text" id='start_date'
                       pattern="(0[1-9]|1[0-9]|2[0-9]|3[01]).(0[1-9]|1[012]).[0-9]{4}">
                <label class="mdl-textfield__label mdl-textfield__label--icon-right"
                       for="timeframe_end_date">DD.MM.YYYY</label>
            </div>
          </div>
          <div class="mdl-dialog__actions">
            <button class="mdl-button" data-mdl-click="onCancel()">
              {{noButton}}
            </button>
            <button class="mdl-button mdl-button--colored" data-mdl-click="onSubmit()">
              {{yesButton}}
            </button>
          </div>
        </div>
        """;
}