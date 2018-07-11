import "dart:html" as dom;
import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import 'package:dryice/dryice.dart';
import 'package:reflected_mustache/mustache.dart';

import 'main.reflectable.dart';

typedef void RemoveCallback(final NameForRepeatSample name);

@inject @mustache
class NameForRepeatSample {
    final Logger _logger = new Logger('main.Name');

    static int _counter = 0;
    int _id = 0;

    final RemoveCallback _callback;

    final String name;

    String get id => _id.toString();

    NameForRepeatSample(this.name,this._callback) { _id = _counter++; }

    void clicked(final String value) {
        _logger.info("Clicked on $value");
    }

    void remove() {
        _logger.info("Remove ID $id");
        _callback(this);
    }
}

main() async {
    // final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run(enableVisualDebugging: true);

    Future _addNamesProgrammatically() async {
        final Logger _logger = new Logger('main._addNamesProgrammatically');

        final MaterialRepeat repeater = MaterialRepeat.widget(dom.querySelector("#main"));

        final names = new List<NameForRepeatSample>();
        final RemoveCallback removeCallback = (final NameForRepeatSample nameToRemove) {
            _logger.fine("Name to remove: ${nameToRemove.name}");

            repeater.remove(new Pair("nrfs", nameToRemove));
            names.remove(nameToRemove);
        };

        names.add(new NameForRepeatSample("A - Nicki",removeCallback));
        names.add(new NameForRepeatSample("B - Mike",removeCallback));
        names.add(new NameForRepeatSample("C - Gerda",removeCallback));
        names.add(new NameForRepeatSample("D - Sarah",removeCallback));

        await repeater.add(new Pair("nfrs", new NameForRepeatSample("A - Nicki II",removeCallback)));
        //await repeater.add({ "name" : names });

        await Future.forEach(names, (final NameForRepeatSample name) async {
            await repeater.add(new Pair("nfrs", name ));
        });

        void _test0(final int milliseconds) {

            new Timer(new Duration(milliseconds: milliseconds), () {
                final name = names.getRange(1, 2).first; // Mike
                final String idForCheckbox = "#check-${name.id}";

                final MaterialCheckbox checkbox = MaterialCheckbox.widget(dom.querySelector(idForCheckbox));
                checkbox.check();
                // check it!
            });
        }

        void _test1(final int milliseconds) {
            new Timer(new Duration(milliseconds: milliseconds), () {
                final name = names.getRange(2,3).first;
                names.remove(name);
                repeater.remove(new Pair("nfrs", name ));
            });
        }

        void _test2(final int milliseconds) {

            final hudriwudri = new NameForRepeatSample("HudriWudri",removeCallback);
            new Timer(new Duration(milliseconds: milliseconds), () {
                names.insert(2,hudriwudri);
                repeater.insert(2,new Pair("nfrs", hudriwudri ));
            });

            new Timer(new Duration(milliseconds: milliseconds + 1000), () {
                names.remove(hudriwudri);
                repeater.remove(new Pair("nfrs", hudriwudri ));
            });
        }

        void _test3(final int milliseconds) {
            new Timer(new Duration(milliseconds: milliseconds), () async {
                int index1 = 1;
                int index2 = 2;

                final item1 = names[index1];
                final item2 = names[index2];

                _logger.fine("Swap in main: ${item1.name} -> ${item2.name}");
                names[index2] = item1;
                names[index1] = item2;
                await repeater.swap(new Pair("nfrs", item1 ),new Pair("nfrs", item2 ));
            });
        }

        void _test4(final int milliseconds) {
            new Timer(new Duration(milliseconds: milliseconds), () {
                Stopwatch stopwatch = new Stopwatch()
                    ..start();
                final List<Future> futures = new List<Future>();

                int i = 0;
                for (;i < 10;i++) {
                    final name = new NameForRepeatSample("Name: $i", removeCallback);

                    names.add(name);
                    futures.add(repeater.add(new Pair("nfrs", name )));
                }
                Future.wait(futures).then((_) {
                    stopwatch.stop();
                    _logger.info("Adding ${i} number of items took ${stopwatch.elapsedMilliseconds}ms");
                });
            });
        }

        void _test5(final int milliseconds) {

            new Timer(new Duration(milliseconds: milliseconds), () {
                final int FPS = (1000 / 50).ceil();
                _logger.info("Frames per sec: ${(1000 / FPS).ceil() }");

                int index = 0;
                for (int i = 0;i < names.length * 10;i++) {
                    if (index >= names.length) {
                        index = 0;
                    }
                    final int index1 = index;
                    final int index2 = index + 1 < names.length ? index + 1 : 0;

                    _logger.fine("Swap $index1 with $index2");

                    new Future.delayed(new Duration(milliseconds: (i + 1) * FPS), () async {

                        _logger.fine("InnerSwap $index1 with $index2");

                        final item1 = names[index1];
                        final item2 = names[index2];

                        names[index1] = item2;
                        names[index2] = item1;

                        await repeater.swap(new Pair("nfrs", item1 ),new Pair("nfrs", item2 ));
                    });

                    index++;
                }
            });
        }

//        _test0(500);
//        _test1(1500);
//        _test2(2500);
//        _test3(4500);
//        _test4(5500);
//        _test5(6500);

    }

    _addNamesProgrammatically();
}
