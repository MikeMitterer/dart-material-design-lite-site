library gensamples;

import 'package:grinder/grinder.dart';
import 'package:mdl/src/grinder/grinder.dart' as mdl;
import 'dart:io';

/// No @DefaultTask() here - we will what time brings...
main(final List<String> args) => grind(args);

@Task()
@Depends(buildSamples, buildSite )
build() {}

@Task()
@Depends(runSiteGen, analyzeSite )
buildSite() {
    Pub.build();

    runTGZSamples();
    runSyncSite();
}

@Task()
@Depends(genSamples,genStyleguide, runSiteGenForSamples, checkForPubspecYaml)
buildSamples() async {
    // Update Sample
    await runAsync("/Users/mikemitterer/.pub-cache/bin/buildSamples",arguments: [ "-u" ]);

    // Analyze
    analyze();

    // Build!
    await runAsync("/Users/mikemitterer/.pub-cache/bin/buildSamples",arguments: [ "-bcr" ]);
}

@Task()
@Depends(analyzeSite,analyzeSamples)
analyze() { }

@Task()
analyzeSamples() {
    final List<String> samples = [
        "mdl_animation/web/main.dart",
        "mdl_badge/web/main.dart",
        "mdl_button/web/main.dart",
        "mdl_card/web/main.dart",
        "mdl_checkbox/web/main.dart",
        "mdl_data-table/web/main.dart",
        "mdl_footer/web/main.dart",
        "mdl_grid/web/main.dart",
        "mdl_icon-toggle/web/main.dart",
        "mdl_layout/web/main.dart",
        "mdl_menu/web/main.dart",
        "mdl_palette/web/main.dart",
        "mdl_progress/web/main.dart",
        "mdl_radio/web/main.dart",
        "mdl_shadow/web/main.dart",
        "mdl_slider/web/main.dart",
        "mdl_spinner/web/main.dart",
        "mdl_switch/web/main.dart",
        "mdl_tabs/web/main.dart",
        "mdl_textfield/web/main.dart",
        "mdl_tooltip/web/main.dart",
        "mdl_typography/web/main.dart",
        "mdld_attribute/web/main.dart",
        "mdld_class/web/main.dart",
        "mdld_formatter/web/main.dart",
        "mdld_model/web/main.dart",
        "mdld_observe/web/main.dart",
        "mdld_repeat/web/main.dart",
        "mdld_repeat_data-table/web/main.dart",
        "mdld_repeat_callback/web/main.dart",
        "mdlo_icons/web/main.dart",
        "mdlo_list/web/main.dart",
        "mdlx_accordion/web/main.dart",
        "mdlx_data-table2/web/main.dart",
        "mdlx_dialog/web/main.dart",
        "mdlx_dnd/web/main.dart",
        "mdlx_forms/web/main.dart",
        "mdlx_nav-pills/web/main.dart",
        "mdlx_notification/web/main.dart",
        "mdlx_panel/web/main.dart",
        "mdlx_snackbar/web/main.dart",
        "spa_chartjs/web/main.dart",
        "spa_content/web/main.dart",
        "spa_include/web/main.dart",
        "spa_inplace/web/main.dart",
        "spa_plotly/web/main.dart",
        "spa_todo/web/main.dart",
        "styleguide/web/main.dart",
        "template_android-dot-com/web/main.dart",
        "template_article/web/main.dart",
        "template_blog/web/main.dart",
        "template_dashboard/web/main.dart",
        "template_fixed-header/web/main.dart",
        "template_spa/web/main.dart",
        "template_sticky-footer/web/main.dart",
        "template_text-only/web/main.dart",
    ];

    samples.forEach((final String sample ) {
        final String sampleFolder = sample.replaceAll("/web/main.dart","");
        run("tool/analyze-sample.sh",arguments: [ "samples/${sampleFolder}", "web/main.dart" ]);
    });
}

@Task()
analyzeSite() {
    Analyzer.analyze("web/main.dart");
}

@Task()
initSamples() => mdl.createSampleList();

@Task()
showConfig() {
    mdl.config.settings.forEach((final String key,final String value) {
        log("${key.padRight(28)}: $value");
    });
}

@Task()
@Depends(initSamples)
listSamples() {
    mdl.samples.forEach((final mdl.Sample sample) {
        log("Name: ${sample.name.padRight(22)} ${sample.type.toString().padRight(15)}\t Dir: ${sample.dirname}");
    });
}

@Task()
@Depends(initSamples)
genSamples() {
    final mdl.SampleGenerator samplegenerator = new mdl.SampleGenerator();

    mdl.samples.where((final mdl.Sample sample) {

        return (sample.type == mdl.Type.Core || sample.type == mdl.Type.DartOld
            || sample.type == mdl.Type.Dart || sample.type == mdl.Type.Directive || sample.type == mdl.Type.SPA);

        //return (sample.name == "animation" || sample.name == "badge" || sample.name == "dialog");
        //return (sample.name == "tabs");

    })
    .forEach((final mdl.Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type},\t main.dart: ${sample.hasOwnDartMain},\t Own demo: ${sample.hasOwnDemoHtml}" );

        samplegenerator.generate(sample);
    });

}

@Task()
@Depends(initSamples)
genStyleguide() {
    final mdl.Styleguide styleguide = new mdl.Styleguide();

    mdl.samples.where((final mdl.Sample sample) {

        return (sample.type == mdl.Type.Core || sample.type == mdl.Type.Dart || sample.type == mdl.Type.Directive ||
                sample.type == mdl.Type.SPA || sample.type == mdl.Type.DartOld) &&
                    sample.excludeFromStyleguide == false;

        // return (sample.name == "accordion");

    })
    .forEach((final mdl.Sample sample) {
        log("Name: ${sample.name.padRight(15)} ${sample.type},\t main.dart: ${sample.hasOwnDartMain},\t Own demo: ${sample.hasOwnDemoHtml}" );

        styleguide.generate(sample);
    });
}

@Task()
runSiteGen() async {
    await runAsync("/Users/mikemitterer/.pub-cache/bin/sitegen",arguments: [ "-g" ]);
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
runSiteGenForSamples() async {
    await runAsync("/Users/mikemitterer/.pub-cache/bin/buildSamples",arguments: [ "--sitegen" ]);
}

@Task()
@Depends(initSamples)
checkForPubspecYaml() {
    final List<String> missingFiles = new List<String>();

    mdl.samples.where((final mdl.Sample sample) => sample.type != mdl.Type.Ignore && sample.type != mdl.Type.Extra)
        .forEach((final mdl.Sample sample) {
            final File file = new File("samples/${sample.prefix}${sample.name}/pubspec.yaml");

            if(!file.existsSync()) {
                missingFiles.add(file.path);
            }
    });

    if(missingFiles.isNotEmpty) {
        throw new ArgumentError("${missingFiles.join(", ")} does not exist!");
    }
}

@Task()
clean() => defaultClean();



