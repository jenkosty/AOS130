%%%%%%%%%%%%%%%%%%%%
%%% STATION DATA %%%
%%%%%%%%%%%%%%%%%%%%

%%% Loading station data
station_data = readtable('station 2.csv');

%%% Getting rid of entries with bad location data
station_data_CA = station_data(station_data.LatitudeMeasure > 0 & station_data.LongitudeMeasure < 0,:);

%%% Plotting stations
figure()
geoaxes
geoscatter(station_data_CA.LatitudeMeasure, station_data_CA.LongitudeMeasure, 10, station_data_CA.CountyCode)
geobasemap bluegreen


%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%% CONTAMINANT DATA %%%
%%%%%%%%%%%%%%%%%%%%%%%%

%%% Loading data
contaminant_data_all = readtable('TC_LA.csv');

%%% Getting rid of entries with bad location data
contaminant_data_all = contaminant_data_all(contaminant_data_all.ActivityLocation_LatitudeMeasure > 0 & contaminant_data_all.ActivityLocation_LongitudeMeasure < 0,:);

%%% Removing unnecessary variables
contaminant_data_all = removevars(contaminant_data_all, {'ActivityStartTime_Time', 'ActivityStartTime_TimeZoneCode', 'ActivityEndDate', 'ActivityEndTime_TimeZoneCode', 'ActivityEndTime_Time'...
    'ActivityRelativeDepthName', 'ActivityDepthAltitudeReferencePointText', 'ActivityTopDepthHeightMeasure_MeasureValue'});

%%% Extracting stations
stations = string(unique(contaminant_data_all.MonitoringLocationIdentifier));

clear contaminant_data_cond
%%% Creating a new data structure
for i = 1:length(stations)
    station_data = contaminant_data_all(string(contaminant_data_all.MonitoringLocationIdentifier) == stations(i),:);
    contaminant_data_cond(i).station = stations(i);
    contaminant_data_cond(i).lat = unique(station_data.ActivityLocation_LatitudeMeasure);
    contaminant_data_cond(i).lon = unique(station_data.ActivityLocation_LongitudeMeasure);
    contaminant_data_cond(i).variable = unique(station_data.CharacteristicName);
    contaminant_data_cond(i).time = station_data.ActivityStartDate;
    contaminant_data_cond(i).measure_value = station_data.ResultMeasureValue;
    contaminant_data_cond(i).start_date = ymd(min(station_data.ActivityStartDate));
    contaminant_data_cond(i).end_date = ymd(max(station_data.ActivityStartDate));
    contaminant_data_cond(i).duration = years(max(station_data.ActivityStartDate) - min(station_data.ActivityStartDate));
end

clear stations station_data i

%%% Plotting stations
figure()
geoaxes
geoscatter([contaminant_data_cond.lat], [contaminant_data_cond.lon], 10, [contaminant_data_cond.duration])
geobasemap bluegreen
colorbar;

%%% Plotting timeseries
scatter(contaminant_data_cond(41).time, contaminant_data_cond(41).measure_value);

