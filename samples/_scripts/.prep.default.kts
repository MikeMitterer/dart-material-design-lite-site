#!/usr/bin/env kscript

//DEPS ch.qos.logback:logback-classic:1.2.2
//DEPS org.slf4j:slf4j-api:1.7.25
//DEPS commons-io:commons-io:2.5
//DEPS at.mikemitterer:builddart:0.0.1

@file:Suppress("PropertyName")

import at.mikemitterer.dbuilder.cpyFile
import at.mikemitterer.dbuilder.logLevel
import at.mikemitterer.dbuilder.properties
import org.apache.commons.io.FilenameUtils
import org.slf4j.LoggerFactory
import java.io.File

val SCRIPT = "${System.getProperty("user.dir")}/.prep.kts"
val SCRIPTPATH = FilenameUtils.getFullPathNoEndSeparator(SCRIPT)!!
val SAMPLE_NAME = FilenameUtils.getBaseName(SCRIPTPATH)!!

private val logger = LoggerFactory.getLogger("$SAMPLE_NAME.prep.kts").apply {
    (this as ch.qos.logback.classic.Logger).level = logLevel
}

logger.debug("Script: $SCRIPT")
logger.debug("Script-Path: $SCRIPTPATH")
logger.debug("Sample: $SAMPLE_NAME")

properties["pubspec.template"]?.apply{

    val filename = this.toString()

    cpyFile(File(filename),
            File(SCRIPTPATH,"pubspec.yaml"),
            mapOf("samplename" to SAMPLE_NAME))

    logger.info("pubspec.yaml update for $SAMPLE_NAME! ")

} ?: run {
    logger.debug("$SAMPLE_NAME has it's own pubspec.yaml! ")
}

