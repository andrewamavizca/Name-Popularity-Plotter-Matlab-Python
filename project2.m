%Andrew Amavizca ME-021
%This file creates a GUI to plot data from a file created using python
%The python file is used through matlab in the gui and is then itterated
%through to provide data for the graph
%plots name and sex chosen, and poplularity or occurences of that name for
%years 1880 through 2017

clear all clc

%%
f = figure('Color',[1 1 1]);

myaxes = axes(f);

% Create axes
myaxes.Units = 'pixels';
myaxes.Position = [49 61 499 273];

%allows us to choose to plot occurences or popularity
chooseplot = uicontrol(f, 'Style', 'text', 'String', 'Select Data', 'Position', [555 224 75 15]);
plotchoices = char('Occurences', 'Popularity');
plotoptions = uicontrol(f, 'Style', 'popup', 'String', plotchoices, 'Position', [640 206 100 40]);

%This is the input for the names GUI
name = uicontrol(f, 'Style', 'text', 'String', 'Enter name', 'Position', [555 196 75 15]);
name_value = uicontrol(f, 'Style', 'edit','Position', [642 192 75 22]);

%Choose sex option in the GUI
choose_sex = uicontrol(f, 'Style', 'text', 'String', 'Sex', 'Position', [557 153 75 25]);
plotchoices2 = char('Male','Female');
plotoptions2 = uicontrol(f, 'Style', 'popup', 'String', plotchoices2, 'Position', [644,154,75,22]);

%Button to plot
buttonplot = uicontrol(f, 'Style', 'pushbutton','Position',[608 81 94 45], 'String', 'Plot Now!', 'callback',{@names_plot,plotoptions,name_value, plotoptions2});



%% This function itterates through the file and plots data accordingly
function names_plot(~,~,plotoptions,name_value, plotoptions2)
what2plot = get(plotoptions, 'Value');
user_name = get(name_value, 'String');
user_sex = get(plotoptions2, 'Value');

%choosing the plot based off of the users choice
%choice 1 being male and 2 being female
if user_sex == 1
    user_sex_value = 'M';
elseif user_sex == 2
    user_sex_value = 'F';
end

%here i am opening the python file and reloading it after each use
mod = py.importlib.import_module('file_create');
py.importlib.reload(mod);

% this is opening the python file and using the search function
% with the data inputed into the GUI
py.file_create.search(user_name,user_sex_value);

%Opening the file and saving the data into a 1x5 cell of cells
f2 = fopen('name_data.txt','r');
filedata1 = textscan(f2,'%s%s%s%s%s%s',1, 'Delimiter', '\t','Headerlines', 1 );
filedata = textscan(f2,'%s%s%s%s', 'Delimiter', '\t', 'Headerlines', 2);
fclose(f2);

%This is itterating through the data file created by the python function
year = filedata{1,1};
instances= filedata{1,2};
popularity = filedata{1,3};
name=filedata1{1,1};
sex =filedata1{1,2};
m1 = str2double(cell2mat(filedata1{1,3}));
b1 = str2double(cell2mat(filedata1{1,4}));
m2 = str2double(cell2mat(filedata1{1,5}));
b2 = str2double(cell2mat(filedata1{1,6}));

%setting up our data to be plotted
%we have to transform the cell arrays
x = year(:,1);
y = instances(:,1 );
y1 = popularity(:,1 );
x = x.';
y = y.';
y1 = y1.';

x = cellfun(@str2double,x);
y = cellfun(@str2double,y);
y1 = cellfun(@str2double,y1);
x1 = min(x):1:max(x);
plotavg1 = m1*x1 + b1;
plotavg2 = m2*x + b2;

%%

% if the first option for male is chosen
if what2plot == 1
    %were going to plot the graph with occurences
    
    p1 = plot(x,y,'o',x,plotavg1);
    title(cell2mat(name),'FontSize',12);
    p1(1).Color='red';
    p1(1).LineWidth = 1.5;
    p1(2).Color='blue';
    p1(1).MarkerSize = 4;
    xlabel('Year','FontWeight','bold');
    ylabel('Instances of this name','FontWeight','bold');
    legend('SSN data',['m = ',num2str(m1),',  b = ',num2str(b1)]);
    legend('Position',[0.671610241147774 0.696423519982242 0.227272722317557 0.086904759634109]);

%if the second option is chosen
elseif what2plot ==2
    %were going to plot the graph with popularity
    p1 = plot(x,y1,'o',x,plotavg2);
    title(cell2mat(name),'FontSize',12);
    p1(1).Color='red';
    p1(1).LineWidth = 1.5;
    p1(2).Color='blue';
    p1(1).MarkerSize = 4;
    xlabel('Year');
    ylabel('Popularity(per thousand instances)','FontWeight','bold')
    legend('SSN data',['m = ',num2str(m2),',  b = ',num2str(b2)]);
    legend('Position',[0.671610241147774 0.696423519982242 0.227272722317557 0.086904759634109]);

end
end