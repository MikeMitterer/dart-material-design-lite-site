library gensamples;

import 'dart:io';
import 'dart:convert';

import 'package:grinder/grinder.dart';
import 'package:mdl/src/grinder/grinder.dart';

main(args) => grind(args);

@Task()
test() => new TestRunner().testAsync();

@DefaultTask()
@Depends(runSiteGen)
build() {
    Pub.build();

    runTGZSamples();
    runSyncSite();
}

@Task()
clean() => defaultClean();

@Task()
initSamples() => createSampleList();

@Task()
showConfig() {
    config.settings.forEach((final String key,final String value) {
        log("${key.padRight(28)}: $value");
    });
}

@Task()
@Depends(initSamples)
listSamples() {
    samples.forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(22)} ${sample.type.toString().padRight(15)}\t Dir: ${sample.dirname}");
    });
}

@Task()
@Depends(initSamples)
genSamples() {
    final SampleGenerator samplegenerator = new SampleGenerator();

    samples.where((final Sample sample) {

        return (sample.type == Type.Core || sample.type == Type.DartOld
            || sample.type == Type.Dart || sample.type == Type.Directive || sample.type == Type.SPA);

        //return (sample.name == "animation" || sample.name == "badge" || sample.name == "dialog");
        //return (sample.name == "tabs");

    })
    .forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type},\t main.dart: ${sample.hasOwnDartMain},\t Own demo: ${sample.hasOwnDemoHtml}" );

        samplegenerator.generate(sample);
    });

}

@Task()
@Depends(initSamples)
genStyleguide() {
    final Styleguide styleguide = new Styleguide();

    samples.where((final Sample sample) {

        return (sample.type == Type.Core || sample.type == Type.Dart || sample.type == Type.Directive ||
                sample.type == Type.SPA || sample.type == Type.DartOld) &&
                    sample.excludeFromStyleguide == false;

        // return (sample.name == "accordion");

    })
    .forEach((final Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type},\t main.dart: ${sample.hasOwnDartMain},\t Own demo: ${sample.hasOwnDemoHtml}" );

        styleguide.generate(sample);
    });
}

@Task()
runSiteGen() {
    run("/Users/mikemitterer/.pub-cache/bin/sitegen",arguments: [ "-g" ]);
}

@Task()
runTGZSamples() {
    run("./tgzsample",arguments: [ "--genall" ]);
}

@Task()
@Depends(runTGZSamples)
runSyncSite() {
    run("./syncsite",arguments: []);
}

@Task()
@Depends(genSamples,genStyleguide)
runSiteGenForSamples() {
    run("/Users/mikemitterer/.pub-cache/bin/buildSamples",arguments: [ "--sitegen" ]);
}

@Task()
@Depends(runSiteGenForSamples)
buildSamples() {
    run("/Users/mikemitterer/.pub-cache/bin/buildSamples",arguments: [ "-ubcr" ]);
}
