%% Add library to path
addpath(pwd);
addpath('drivers/DHT');
addpath('drivers/LPS331');
savepath;

%% Refresh library browser
lb = LibraryBrowser.LibraryBrowser2;
refresh(lb);
