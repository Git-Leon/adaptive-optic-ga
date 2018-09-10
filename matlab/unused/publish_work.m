%options = struct('format','pdf','outputDir','C:\myPublishedOutput')
close all;
publish(uigetfile('*.m'),'doc') 
close all;