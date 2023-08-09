function varargout = maskmaker(varargin)
% MASKMAKER MATLAB code for maskmaker.fig
%      MASKMAKER, by itself, creates a new MASKMAKER or raises the existing
%      singleton*.
%
%      H = MASKMAKER returns the handle to a new MASKMAKER or the handle to
%      the existing singleton*.
%
%      MASKMAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASKMAKER.M with the given input arguments.
%
%      MASKMAKER('Property','Value',...) creates a new MASKMAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maskmaker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maskmaker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help maskmaker

% Last Modified by GUIDE v2.5 21-Jul-2022 16:42:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maskmaker_OpeningFcn, ...
                   'gui_OutputFcn',  @maskmaker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before maskmaker is made visible.
function maskmaker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maskmaker (see VARARGIN)

% Choose default command line output for maskmaker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes maskmaker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = maskmaker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbadd2mask.
function pbadd2mask_Callback(hObject, eventdata, handles)
% hObject    handle to pbadd2mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addmask

% --- Executes on button press in pbremovefrommask.
function pbremovefrommask_Callback(hObject, eventdata, handles)
% hObject    handle to pbremovefrommask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rmmask

% --- Executes on button press in pbinvertselection.
function pbinvertselection_Callback(hObject, eventdata, handles)
% hObject    handle to pbinvertselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
invert

% --- Executes on button press in pbdrawpolygon.
function pbdrawpolygon_Callback(hObject, eventdata, handles)
% hObject    handle to pbdrawpolygon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawpolygon

% --- Executes on button press in pbdrawcircle.
function pbdrawcircle_Callback(hObject, eventdata, handles)
% hObject    handle to pbdrawcircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawc

% --- Executes on button press in pbsavemask.
function pbsavemask_Callback(hObject, eventdata, handles)
% hObject    handle to pbsavemask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savemask(handles)

% --- Executes on button press in pbloadmask.
function pbloadmask_Callback(hObject, eventdata, handles)
% hObject    handle to pbloadmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadmask

% --- Executes on button press in pbshowmask.
function pbshowmask_Callback(hObject, eventdata, handles)
% hObject    handle to pbshowmask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject, 'string')
    case 'Show mask'
        showmask(hObject, eventdata, handles)        
        set(hObject, 'string', 'Show image');
    case 'Show image'
        showimage(hObject, eventdata, handles)
        set(hObject, 'string', 'Show mask');
end



function edmaskname_Callback(hObject, eventdata, handles)
% hObject    handle to edmaskname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edmaskname as text
%        str2double(get(hObject,'String')) returns contents of edmaskname as a double


% --- Executes during object creation, after setting all properties.
function edmaskname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edmaskname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbhisto.
function pbhisto_Callback(hObject, eventdata, handles)
% hObject    handle to pbhisto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = findobj('tag', 'Figure_mask');
%ax = findall(f, 'type', 'image');
img = getappdata(f, 'sensitivity_image');
[n,x] = hist(img(:), 0:0.02:5);
        
f = ezfit(x, n, 'gauss');
figure;
plot(x, n, 'o');showfit(f)



% --- Executes on button press in pbsetthresh.
function pbsetthresh_Callback(hObject, eventdata, handles)
% hObject    handle to pbsetthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showimage([],[], handles)
f = findobj('tag', 'Figure_mask');
%ax = findall(f, 'type', 'image');
img = getappdata(f, 'sensitivity_image'); 
if isempty(img)
    img = double(getappdata(f, 'image'));
end
lim = eval(get(handles.ed_thresh, 'string'));
ll = lim(1); ul = lim(2);
mask = ones(size(img));
mask(img<ll) = 0;
mask(img>ul) = 0;

showm(mask);
assignin('base', 'tmpmask', mask);


function ed_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to ed_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_thresh as text
%        str2double(get(hObject,'String')) returns contents of ed_thresh as a double


% --- Executes during object creation, after setting all properties.
function ed_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edlowlimit_Callback(hObject, eventdata, handles)
% hObject    handle to edlowlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edlowlimit as text
%        str2double(get(hObject,'String')) returns contents of edlowlimit as a double
pbsetscale_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edlowlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edlowlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbsetscale.
function pbsetscale_Callback(hObject, eventdata, handles)
% hObject    handle to pbsetscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = findobj('tag', 'Figure_mask');
%if isempty(f)
%    f = figure;
%    set(f, 'tag', 'Figure_mask');
%end
%img = getappdata(f, 'image');
figure(f)
ax = findall(f, 'type', 'axes');
%set(ax, 'cLimmode', climmode);
ll = str2double(get(handles.edlowlimit, 'string'));
hl = str2double(get(handles.edhighlimit, 'string'));
set(ax, 'cLim', [ll,hl]);
%drawnow
%imagesc(img, [ll, hl]);
%imagesc(img, [ll, hl], 'parents', ax);
%setappdata(f, 'image', img);

% --- Executes on button press in pbloglin.
function pbloglin_Callback(hObject, eventdata, handles)
% hObject    handle to pbloglin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = findobj('tag', 'Figure_mask');
ax = findall(f, 'type', 'image');
img = double(getappdata(f, 'image'));
imscale = getappdata(f, 'imagescale');
if imscale == 0
    set(ax, 'cdata', log10(abs(img)));
    setappdata(f, 'imagescale', 1);
else
    set(ax, 'cdata', img);
    setappdata(f, 'imagescale', 0);
end
pbsetscale_Callback(hObject, eventdata, handles)
        



function edhighlimit_Callback(hObject, eventdata, handles)
% hObject    handle to edhighlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edhighlimit as text
%        str2double(get(hObject,'String')) returns contents of edhighlimit as a double
pbsetscale_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edhighlimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edhighlimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


    function pb_gcmasking_Callback(hObject, eventdata, handles)
        % assuming there are azimavgmap available.
        azimavgmap = evalin('base', 'azimavgmap');
        f = findobj('tag', 'Figure_mask');
        img = getappdata(f, 'image');
        load L17_12IDB.mat;
        ref = L17_12IDB;
        gc = interp1(ref(:,1), ref(:,2), azimavgmap.qmap);
        gc = reshape(gc, size(img));
        gc = gc/mean(gc(:));
        img = img/mean(img(:)); 
        m = gc./img;
        mask = ones(size(m));
        mask(m>2) = 0;
        mask(isinf(m)) = 0;
        mask(m<=0) = 0;
        t = find(mask == 0);
        img2 = img;img2(t) = [];
        mean_goodpix = mean(img2);
        img = img/mean_goodpix;
        img2=img2/mean_goodpix;
        gc2=gc;gc2(t) = [];
        mean_goodpix_gc = mean(gc2);
        gc2 = gc2/mean_goodpix_gc;
        gc = gc/mean_goodpix_gc;
        img = img./gc;
        setappdata(f, 'sensitivity_image', img);
        showm(mask);
        assignin('base', 'tmpmask', mask);

% --- Executes on button press in pbsmooth.
function pbsmooth_Callback(hObject, eventdata, handles)
% hObject    handle to pbsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%gc = evalin('base', 'gc');
 gc = [0.0063   41.2739
    0.0072   39.4490
    0.0081   38.6674
    0.0090   38.2356
    0.0099   37.9955
    0.0108   37.6382
    0.0117   36.9394
    0.0126   36.5603
    0.0135   36.6277
    0.0144   36.5361
    0.0153   35.7443
    0.0162   35.8664
    0.0171   35.0903
    0.0180   35.0126
    0.0189   35.1064
    0.0198   34.5533
    0.0207   34.4455
    0.0216   34.3759
    0.0225   34.0067
    0.0234   33.6900
    0.0243   33.7166
    0.0252   33.4428
    0.0261   33.1734
    0.0270   33.1718
    0.0279   32.9530
    0.0288   32.7905
    0.0297   32.5111
    0.0306   32.4417
    0.0315   32.5191
    0.0324   32.2882
    0.0333   32.1144
    0.0342   32.0581
    0.0351   32.0247
    0.0360   31.7302
    0.0369   31.6690
    0.0378   31.5375
    0.0387   31.3582
    0.0396   31.1881
    0.0406   31.4062
    0.0415   31.2941
    0.0424   31.1123
    0.0433   31.0548
    0.0442   30.8880
    0.0451   30.9037
    0.0460   30.7206
    0.0469   30.6986
    0.0478   30.6643
    0.0487   30.7806
    0.0496   30.5652
    0.0505   30.3721
    0.0514   30.5102
    0.0523   30.7354
    0.0532   30.5131
    0.0541   30.5610
    0.0550   30.5022
    0.0559   30.2876
    0.0568   30.3371
    0.0577   30.2450
    0.0586   30.4042
    0.0595   30.2769
    0.0604   30.1234
    0.0613   30.3692
    0.0622   30.2567
    0.0631   30.3946
    0.0640   30.3688
    0.0649   30.3031
    0.0658   30.1799
    0.0667   30.3079
    0.0676   30.2667
    0.0685   30.1389
    0.0694   30.2408
    0.0703   30.1356
    0.0712   30.0722
    0.0721   29.9960
    0.0730   30.0016
    0.0739   29.9239
    0.0748   30.1480
    0.0757   29.9021
    0.0766   29.8931
    0.0775   29.8983
    0.0784   29.9258
    0.0793   29.8156
    0.0802   29.8080
    0.0811   29.6573
    0.0820   29.7428
    0.0829   29.5192
    0.0838   29.5156
    0.0847   29.4622
    0.0856   29.3378
    0.0865   29.2300
    0.0874   29.2736
    0.0883   29.2317
    0.0892   29.0075
    0.0901   28.9989
    0.0910   28.8525
    0.0919   28.8295
    0.0928   28.6803
    0.0937   28.7166
    0.0946   28.5722
    0.0955   28.2118
    0.0964   28.1147
    0.0973   28.1376
    0.0982   28.0553
    0.0991   27.8474
    0.1000   27.7929
    0.1009   27.6579
    0.1018   27.5261
    0.1027   27.3295
    0.1036   27.2629
    0.1045   27.0936
    0.1054   26.9688
    0.1063   26.8030
    0.1072   26.6893
    0.1081   26.4965
    0.1090   26.2968
    0.1099   26.1365
    0.1108   25.9110
    0.1117   25.7964
    0.1126   25.6848
    0.1135   25.4902
    0.1144   25.3623
    0.1153   25.1310
    0.1162   24.8886
    0.1171   24.8140
    0.1180   24.4854
    0.1189   24.3451
    0.1198   24.1938
    0.1208   23.9728
    0.1217   23.8274
    0.1226   23.5537
    0.1235   23.4519
    0.1244   23.3160
    0.1253   23.0816
    0.1262   23.0165
    0.1271   22.6742
    0.1280   22.6221
    0.1289   22.3020
    0.1298   22.1916
    0.1307   21.8945
    0.1316   21.7871
    0.1325   21.5110
    0.1334   21.3129
    0.1343   21.1013
    0.1352   20.8992
    0.1361   20.7603
    0.1370   20.4468
    0.1379   20.3584
    0.1388   20.1140
    0.1397   19.8982
    0.1406   19.7324
    0.1415   19.5570
    0.1424   19.3080
    0.1433   19.1626
    0.1442   18.9771
    0.1451   18.7968
    0.1460   18.6097
    0.1469   18.4120
    0.1478   18.2410
    0.1487   17.9903
    0.1496   17.8042
    0.1505   17.5352
    0.1514   17.3845
    0.1523   17.1631
    0.1532   16.9755
    0.1541   16.7650
    0.1550   16.6417
    0.1559   16.3919
    0.1568   16.2886
    0.1577   16.1086
    0.1586   15.8877
    0.1595   15.7268
    0.1604   15.5187
    0.1613   15.3451
    0.1622   15.2337
    0.1631   15.0449
    0.1640   14.8966
    0.1649   14.6407
    0.1658   14.4795
    0.1667   14.2666
    0.1676   14.1955
    0.1685   14.0438
    0.1694   13.7867
    0.1703   13.6484
    0.1712   13.5028
    0.1721   13.4108
    0.1730   13.2159
    0.1739   12.9921
    0.1748   12.8493
    0.1757   12.7054
    0.1766   12.5414
    0.1775   12.3886
    0.1784   12.2062
    0.1793   12.1547
    0.1802   11.9201
    0.1811   11.7766
    0.1820   11.6400
    0.1829   11.5113
    0.1838   11.3574
    0.1847   11.2848
    0.1856   11.1059
    0.1865   10.9616
    0.1874   10.8294
    0.1883   10.6301
    0.1892   10.5226
    0.1901   10.4190
    0.1910   10.2665
    0.1919   10.0951
    0.1928    9.9948
    0.1937    9.9479
    0.1946    9.8172
    0.1955    9.5638
    0.1964    9.4923
    0.1973    9.4249
    0.1982    9.2537
    0.1991    9.1267
    0.2001    9.0536
    0.2010    8.9060
    0.2019    8.8463
    0.2028    8.7422
    0.2037    8.5505
    0.2046    8.4751
    0.2055    8.3637
    0.2064    8.2401
    0.2073    8.1432
    0.2082    8.0287
    0.2091    7.9340
    0.2100    7.8333
    0.2109    7.7384
    0.2118    7.6506
    0.2127    7.5530
    0.2136    7.4034
    0.2145    7.3778
    0.2154    7.2525
    0.2163    7.1598
    0.2172    7.0717
    0.2181    6.9957
    0.2190    6.8898
    0.2199    6.7976
    0.2208    6.7287
    0.2217    6.6526
    0.2226    6.5855
    0.2235    6.4749
    0.2244    6.3761
    0.2253    6.2949
    0.2262    6.2308
    0.2271    6.1614
    0.2280    6.0973
    0.2289    5.9733
    0.2298    5.9151
    0.2307    5.8693
    0.2316    5.7730
    0.2325    5.6984
    0.2334    5.6388
    0.2343    5.5517
    0.2352    5.4652
    0.2361    5.4246
    0.2370    5.3571
    0.2379    5.2870
    0.2388    5.2248
    0.2397    5.1674
    0.2406    5.0884
    0.2415    5.0360
    0.2424    4.9708
    0.2433    4.9462
    0.2442    4.8633
    0.2451    4.7809
    0.2460    4.7317
    0.2469    4.6676
    0.2478    4.6477
    0.2487    4.5429
    0.2496    4.5023
    0.2505    4.4521
    0.2514    4.3796
    0.2523    4.3290
    0.2532    4.2938
    0.2541    4.2271
    0.2550    4.2077
    0.2559    4.1467
    0.2568    4.1205
    0.2577    4.0466
    0.2586    4.0129
    0.2595    3.9506
    0.2604    3.9048
    0.2613    3.8592
    0.2622    3.8146
    0.2631    3.7702
    0.2640    3.7430
    0.2649    3.6633
    0.2658    3.6302
    0.2667    3.6187
    0.2676    3.5372
    0.2685    3.5163
    0.2694    3.4780
    0.2703    3.4389
    0.2712    3.4176
    0.2721    3.3606
    0.2730    3.3329
    0.2739    3.2616
    0.2748    3.2281
    0.2757    3.1791
    0.2766    3.1823
    0.2775    3.1776
    0.2784    3.1099
    0.2793    3.0726
    0.2803    3.0378
    0.2812    3.0482
    0.2821    2.9736
    0.2830    2.9454
    0.2839    2.9317
    0.2848    2.8868
    0.2857    2.8535
    0.2866    2.8383
    0.2875    2.7897
    0.2884    2.7781
    0.2893    2.7349
    0.2902    2.7189
    0.2911    2.6779
    0.2920    2.6547
    0.2929    2.6372
    0.2938    2.6145
    0.2947    2.5695
    0.2956    2.5453
    0.2965    2.4988
    0.2974    2.4872
    0.2983    2.4700
    0.2992    2.4369
    0.3001    2.4169
    0.3010    2.4064
    0.3019    2.3795
    0.3028    2.3368
    0.3037    2.3028
    0.3046    2.3254
    0.3055    2.2766
    0.3064    2.2425
    0.3073    2.2033
    0.3082    2.2297
    0.3091    2.1913
    0.3100    2.1718
    0.3109    2.1548
    0.3118    2.1296
    0.3127    2.1103
    0.3136    2.0851
    0.3145    2.0552
    0.3154    2.0603
    0.3163    2.0402
    0.3172    2.0209
    0.3181    1.9918
    0.3190    1.9680
    0.3199    1.9605
    0.3208    1.9295
    0.3217    1.9101
    0.3226    1.8993
    0.3235    1.8957
    0.3244    1.8734
    0.3253    1.8520
    0.3262    1.8526
    0.3271    1.8150
    0.3280    1.7976
    0.3289    1.7899
    0.3298    1.7664
    0.3307    1.7330
    0.3316    1.7523
    0.3325    1.7081
    0.3334    1.7023
    0.3343    1.6848
    0.3352    1.6533
    0.3361    1.6654
    0.3370    1.6451
    0.3379    1.6339
    0.3388    1.6020
    0.3397    1.6076
    0.3406    1.5986
    0.3415    1.5846
    0.3424    1.5631
    0.3433    1.5511
    0.3442    1.5389
    0.3451    1.5146
    0.3460    1.5078
    0.3469    1.5030
    0.3478    1.4827
    0.3487    1.4653
    0.3496    1.4456
    0.3505    1.4466
    0.3514    1.4370
    0.3523    1.4195
    0.3532    1.4091
    0.3541    1.4138
    0.3550    1.3980
    0.3559    1.3511
    0.3568    1.3603
    0.3577    1.3725
    0.3586    1.3548
    0.3595    1.3216
    0.3605    1.3107
    0.3614    1.3170
    0.3623    1.2970
    0.3632    1.3040
    0.3641    1.2815
    0.3650    1.2693
    0.3659    1.2779
    0.3668    1.2618
    0.3677    1.2517
    0.3686    1.2169
    0.3695    1.2236
    0.3704    1.2003
    0.3713    1.2110
    0.3722    1.1978
    0.3731    1.1721
    0.3740    1.1858
    0.3749    1.1744
    0.3758    1.1485
    0.3767    1.1471
    0.3776    1.1400
    0.3785    1.1373
    0.3794    1.1299
    0.3803    1.1095
    0.3812    1.1020
    0.3821    1.0930
    0.3830    1.0903
    0.3839    1.0657
    0.3848    1.0783
    0.3857    1.0768
    0.3866    1.0580
    0.3875    1.0392
    0.3884    1.0321
    0.3893    1.0349
    0.3902    1.0454
    0.3911    1.0334
    0.3920    1.0147
    0.3929    1.0066
    0.3938    1.0003
    0.3947    0.9907
    0.3956    0.9822
    0.3965    0.9885
    0.3974    0.9665
    0.3983    0.9585
    0.3992    0.9568
    0.4001    0.9590
    0.4010    0.9356
    0.4019    0.9354
    0.4028    0.9257
    0.4037    0.9179
    0.4046    0.9189
    0.4055    0.9057
    0.4064    0.9032
    0.4073    0.8970
    0.4082    0.9040
    0.4091    0.8883
    0.4100    0.8740
    0.4109    0.8787
    0.4118    0.8650
    0.4127    0.8570
    0.4136    0.8597
    0.4145    0.8439
    0.4154    0.8423
    0.4163    0.8332
    0.4172    0.8290
    0.4181    0.8302
    0.4190    0.8289
    0.4199    0.8078
    0.4208    0.8089
    0.4217    0.8127
    0.4226    0.8017
    0.4235    0.7862
    0.4244    0.7739
    0.4253    0.7856
    0.4262    0.7893
    0.4271    0.7776
    0.4280    0.7610
    0.4289    0.7542
    0.4298    0.7595
    0.4307    0.7477
    0.4316    0.7488
    0.4325    0.7427
    0.4334    0.7406
    0.4343    0.7365
    0.4352    0.7304
    0.4361    0.7229
    0.4370    0.7186
    0.4379    0.7152
    0.4388    0.7089
    0.4397    0.7108
    0.4407    0.7112
    0.4416    0.6916
    0.4425    0.6891
    0.4434    0.6902
    0.4443    0.6748
    0.4452    0.6882
    0.4461    0.6770
    0.4470    0.6781
    0.4479    0.6636];







saxs = getgihandle;
%mask = zeros(size(saxs.image));
[x, y] = size(saxs.image);
[Y, X] = meshgrid(1:y, 1:x);
q = saxs.pxQ*sqrt((X-saxs.center(2)).^2 + (Y-saxs.center(1)).^2);

q2 = 0:0.00001:(gc(1,1)-diff(gc(1:2), 1));
x2 = log10(gc(:,1));
y2 = log10(gc(:,2));
dt = polyfit(x2(1:2), y2(1:2), 1);
gc_qmin_fit = 10.^(log10(q2)*dt(1)+dt(2));
gc = [q2(:), gc_qmin_fit(:); gc];

Z = interp1(gc(:,1), gc(:,2), q(:));
Z = reshape(Z, size(saxs.image));
mask = saxs.image./Z;

% making a mask
mask(isnan(mask)) = 0;
mask_mean = mean(mean(mask))/2;

masked = mask;
ind = find(masked<mask_mean);
[maskrow, maskcol] = ind2sub(size(masked), ind);
newr = maskrow;
newc = maskcol;

mask(mask < mask_mean) = 0;
mask(mask >= mask_mean) = 1;
masksize = size(mask);
fprintf('Preliminary mask computed from the glass carbon is ready\n');
%% find egde
edgern = newr;
edgecn = newc;
tmask = masked;
tmask((mask == 0)) = [];
sig = std(tmask(:))*2;
nb = 1;
while ~isempty(edgern)
    switch nb
        case 1
            strn = '1st';
        case 2
            strn = '2nd';
        case 3
            strn = '3rd';
        otherwise
            strn = [num2str(nb), 'th'];
    end
    fprintf('Checking %s neigbhors.\n', strn)
    [edgern, edgecn] = maskedgefinder(edgern, edgecn, masked, sig);
    newr = [newr; edgern(:)];
    newc = [newc; edgecn(:)];
    indn = sub2ind(masksize, edgern(:), edgecn(:));
    mask(indn) = 0;
    nb = nb + 1;
end
%mask = ones(size(mask));
%[maskrow, maskcol] = sub2ind(size(masked), ind);
%mask(newr, newc) = 0;
assignin('base', 'mask', mask);
fprintf('Done.. A mask ready.\n')
%return
%f = findobj('tag', 'Figure_mask');
%ax = findall(f, 'type', 'image');
%img = getappdata(f, 'image');
%st = str2double(get(handles.edsmoothstep, 'string'));
%img = img + [img(end-st+1:end,:); img(1:end-st,:)]+[img(st+1:end,:); img(1:st,:)]...
%    +[img(:,st+1:end), img(:,1:st)]+[img(:,end-st+1:end), img(:,1:end-st)];
%img = img/5;
%set(ax, 'cdata', img);


function edsmoothstep_Callback(hObject, eventdata, handles)
% hObject    handle to edsmoothstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edsmoothstep as text
%        str2double(get(hObject,'String')) returns contents of edsmoothstep as a double


% --- Executes during object creation, after setting all properties.
function edsmoothstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edsmoothstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbloadimage.
function pbloadimage_Callback(hObject, eventdata, handles)
% hObject    handle to pbloadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saxs = getgihandle;
if isempty(saxs)
    img = get(findall(0, 'type', 'image'), 'CData');
else
    if isfield(saxs, 'image')
        if ndims(saxs.image)==3
            img = saxs.image(:, :, saxs.frame);
        else
            img = saxs.image;
        end
    else
        [filename, pathname] = uigetfile('*.*', 'Pick a mask file');
        if isequal(filename,0) || isequal(pathname,0)
            disp('User pressed cancel')
            return
        else
            disp(['User selected ', fullfile(pathname, filename)])
        end
        img = imread(fullfile(pathname, filename));
    end
end
f = findobj('tag', 'Figure_mask');
if isempty(f)
    f = figure;
    set(f, 'tag', 'Figure_mask');
end
ax = findall(f, 'type', 'axes');
%image(img, 'parent', ax);
figure(f);
imagesc(img);
set(findobj(f, 'type', 'axes'), 'cLimmode', 'manual')
setappdata(f, 'image', img);
setappdata(f, 'imagescale', 0);
initiate

%setappdata(f, 'logdata', log10(img));
%setappdata('base', 'mask', mask);
    function initiate(varargin)
        f = findobj('tag', 'Figure_mask');
        img = getappdata(f, 'image');
        sizea = size(img);
        mask = uint8(ones(sizea));
        assignin('base', 'mask', mask);
        assignin('base', 'tmpmask', mask);
        x = 1:sizea(1);
        y = 1:sizea(2);
        [X,Y] = meshgrid(y,x);
        setappdata(f, 'X', X);
        setappdata(f, 'Y', Y);
        %btdfcn = '';
        %tmpmask = [];
        %ctn = [];
        %r = [];
        %maskhandle = [];
        %lh = [];
        
    function loadmask(varargin)
        [filename, pathname] = uigetfile('*.*', 'Pick a mask file');
        if isequal(filename,0) || isequal(pathname,0)
            disp('User pressed cancel')
            return
        else
            disp(['User selected ', fullfile(pathname, filename)])
        end
        msk = imread(fullfile(pathname, filename));
        if isempty(evalin('base', 'mask'))
            assignin('base', 'mask', msk);
            return
        else
            m = evalin('base', 'mask');
            if sum(m(:))==0
                assignin('base', 'mask', msk);
            end
        end
        assignin('base', 'tmpmask', msk);
    
    function loadCoordinates(varargin)
        [filename, pathname] = uigetfile('*.txt', 'Pick a mask file');
        if isequal(filename,0) || isequal(pathname,0)
            disp('User pressed cancel')
            return
        else
            fn = fullfile(pathname, filename);
            disp(['User selected ', fn])
        end
        fid = fopen(fn);
        xy = textscan(fid, '%d %d');
        fclose(fid);
        m = evalin('base', 'mask');
        if isempty(m)
            error('Use this function after a mask is built.')
        end
        if numel(xy)>0
            tmpmsk = zeros(size(m));
            t = sub2ind(size(aa), xy{1}, xy{2});
            tmpmsk(t) = 1;
            assignin('base', 'tmpmask', tmpmsk);
        else
            error('Blank file is loaded.')
        end

    function loadPilatusMask(varargin)
        f = findobj('tag', 'Figure_mask');
        img = getappdata(f, 'image');
        msk = [];
        if size(img,1) == 1679
            try
                [~, filepath] = APS_ch2currentfolder;
            catch
                filepath = pwd;
                isSAXS = strfind(filepath, [filesep, 'SAXS']);
                filepath(isSAXS:end) = [];
            end
            msk = imread(fullfile(filepath, filesep, 'SAXS', filesep, 'goodpix_mask.tif'));
            msk2 = Pilatus2mBad;
            msk = msk & msk2;
        end
        
        if size(img,1) == 619
            try
                [~, filepath] = APS_ch2currentfolder;
            catch
                filepath = pwd;
                isSAXS = strfind(filepath, [filesep, 'WAXS']);
                filepath(isSAXS:end) = [];
            end
            msk = imread(fullfile(filepath, filesep, 'WAXS', filesep, 'goodpix_mask.tif'));
            msk2 = Pilatus300Bad;
            msk = msk & msk2;
        end
        if ~isempty(msk)
            assignin('base', 'tmpmask', msk);
            showm(msk);
        end
        
    function loadSAXSBSmask(varargin)
        load SAXSBSmask.mat;
        oldmask = SAXSBSmask.mask;
        oldcen = SAXSBSmask.center;
        saxs = getgihandle;
        newcen = saxs.center;
        dcx = newcen(1)-oldcen(1);
        dcy = newcen(2)-oldcen(2);
        [X, Y] = meshgrid(1:1475, 1:1679);
        nM = interp2(X+dcx, Y+dcy, double(oldmask), X, Y);
        nM(isnan(nM)) = 1;
        assignin('base', 'tmpmask', nM);
        showm(nM);

    function loadSAXSframemask(varargin)
        is2meter = 0;
        try
            s = getgihandle;
            if (abs(s.SDD-2000) < 1000)
                is2meter = 1;
            end
        catch
            is2meter = 1;
        end
        switch is2meter
            case 0
                load SAXSframemask.mat;
            case 1
                load SAXSframemask2m.mat;
        end
        assignin('base', 'tmpmask', mask);
        showm(mask);
    function loadSAXSCNTBSmask(varargin)
        load SAXSCNTBSmask.mat;
        oldmask = SAXSCNTBSmask.mask;
        oldcen = SAXSCNTBSmask.center;
        saxs = getgihandle;
        newcen = saxs.center;
        dcx = newcen(1)-oldcen(1);
        dcy = newcen(2)-oldcen(2);
        [X, Y] = meshgrid(1:1475, 1:1679);
        nM = interp2(X+dcx, Y+dcy, double(oldmask), X, Y);
        nM(isnan(nM)) = 1;
        assignin('base', 'tmpmask', nM);
        showm(nM);
    function drawpolygon(varargin)
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
        btdfcn = get(f, 'windowbuttondownfcn');
        setappdata(f, 'oldwindowbuttondownfcn', btdfcn);
        set(f, 'windowbuttondownfcn', @gtrack_on);
        set(ax, 'userdata', []);
    
    function gtrack_on(src, event)
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
        switch get(f, 'selectiontype')
        case 'normal'
            pt = get(ax, 'CurrentPoint');
            xInd = pt(1, 1);
            yInd = pt(1, 2);
            t = get(ax, 'userdata');
            t = [t; [xInd, yInd]];
            set(ax, 'userdata', t);
            if numel(t(:,1)) > 1
                lh = line(t(:,1), t(:,2));
                setappdata(f, 'linehandle', lh);
            end
        case 'extend'
            gtrack_off
        case 'alt'
            gtrack_off
%            winBtnDownFcn(handles.ImageAxes);
        otherwise
        end
    
    function gtrack_off
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
        lh = getappdata(f, 'linehandle');
        if ~isempty(lh)
            delete(lh)
            lh = [];
        end
        btdfcn = getappdata(f, 'oldwindowbuttondownfcn');
        set(f, 'windowbuttondownfcn', btdfcn);
            t = get(ax, 'userdata');
            t = [t; [t(1,1), t(1,2)]];
%            set(ax, 'userdata', t);
            if numel(t(:,1)) > 1
                lh = line(t(:,1), t(:,2));
            end
            setappdata(f, 'linehandle', lh);
        makemask(f, ax, t)
        k = findall(f, 'type', 'line');
        delete(k);
    
    function makemask(varargin)
        f = varargin{1};
        ax = varargin{2};
        t = varargin{3};
        X = getappdata(f, 'X');
        Y = getappdata(f, 'Y');
        t = get(ax, 'userdata');
        tmpmask = inpolygon(X(:), Y(:), t(:,1), t(:,2));
        tmpmask = double(tmpmask);
        tmpmask(tmpmask == 0) = 2;
        tmpmask = reshape(tmpmask, size(X));
        tmpmask = tmpmask - 1;
        showm(tmpmask);
        assignin('base', 'tmpmask', tmpmask);
        %assignin('base', 'saxs_mask', mask)
    
    function drawc(varargin)
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
       
        figure(f);
        ctn = ginput(1);
        setappdata(f, 'selectedpnt', ctn);
        set(f, 'windowbuttonmotionfcn', @wdbmf_circle);
        set(ax, 'userdata', []);
        set(f, 'windowbuttondownfcn', @wdbdf_circle);
    
    function wdbmf_circle(varargin)
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
        
        pt = get(ax, 'CurrentPoint');
        ctn = getappdata(f, 'selectedpnt');
        r = sqrt(abs(ctn(1)-pt(1,1)).^2 + abs(ctn(2)-pt(1,2)).^2);
        setappdata(f, 'r', r);
        drawcir(ctn(1), ctn(2), r, 100)
    
    function drawcir(x, y, r, ns)
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
        theta = linspace(0, 2*pi, ns);
        pline_x = r * cos(theta) + x;
        pline_y = r * sin(theta) + y;
        k = findall(ax, 'type', 'line');
        delete(k)
        line(pline_x, pline_y);
    
    function wdbdf_circle(varargin)
        f = findobj('tag', 'Figure_mask');
        ax = findall(f, 'type', 'axes');
        X = getappdata(f, 'X');
        Y = getappdata(f, 'Y');
        ctn = getappdata(f, 'selectedpnt');
        r = getappdata(f, 'r');
        m = sqrt(abs(X-ctn(1)).^2+abs(Y-ctn(2)).^2)-r;
        indx = m > 0;
        %indy = m <= 0;
        tmpmask = zeros(size(X));
        tmpmask(indx) = 1;
        tmpmask = reshape(tmpmask, size(X));
        k = findall(ax, 'type', 'line');
        delete(k)
        showm(tmpmask);
        assignin('base', 'tmpmask', tmpmask);
    
    function varargout = invert(varargin)
        if numel(varargin) == 1
            tmpmask = abs(varargin{1} -1);
            varargout{1} = tmpmask;
        else
            tmpmask = evalin('base', 'tmpmask');
            tmpmask = abs(tmpmask -1);
            showm(tmpmask);
        end
        assignin('base', 'tmpmask', tmpmask);
    
    function rtn = maskand(a,b)
        a = uint8(a);
        b = uint8(b);
        rtn = a & b;
    
    function rtn = maskor(a,b)
        a = uint8(a);
        b = uint8(b);
        rtn = a | b;
    
    function rmmask(varargin)
        tmpmask = evalin('base', 'tmpmask');
        mask = evalin('base', 'mask');
        %mask = mask - uint8(tmpmask);
        tm = invert(tmpmask);
        mask = maskor(mask, tm);
        assignin('base', 'mask', mask);
    
    function addmask(varargin)
        tmpmask = evalin('base', 'tmpmask');
        mask = evalin('base', 'mask');
        %mask = mask.*uint8(tmpmask);
        mask = maskand(mask, tmpmask);
        assignin('base', 'mask', mask);
    
    function showmask(varargin)
        mask = evalin('base', 'mask');
        showm(mask);
        
    function showimage(varargin)
        f = findobj('tag', 'Figure_mask');
        img = getappdata(f, 'image');
        img = double(img);
        %ax = findobj(f, 'type', 'axes');
        ax = findall(f, 'type', 'image');
        imscale = getappdata(f, 'imagescale');
        if imscale == 1
            set(ax, 'cdata', log10(abs(img)));
            %setappdata(f, 'imagescale', 1);
        else
            set(ax, 'cdata', img);
            %setappdata(f, 'imagescale', 0);
        end
        pbsetscale_Callback([],[],varargin{3})

        %set(ax, 'cdata', img);
        E = ones(size(img));
        [ver, dat] = version();
        t = findstr(ver, '.');ver = str2double(ver(1:t(2)-1));
        if ver >= 8.5
            set(ax, 'alphadata', E, 'AlphaDataMapping', 'none');
        else
            set(ax, 'alphadata', E);
        end
        
    function showm(msk)
        f = findobj('tag', 'Figure_mask');
        try
        if ~isempty(maskhandle)
            delete(maskhandle)
            maskhandle = [];
        end
        catch
            maskhandle = [];
        end
        %hold on;
        %maskhandle = image(E);
        %hold off;
        %E = abs(msk-1)*0.5; %E = E*0.5;
        %E = uint8(abs(msk));
        E = abs(double(msk));
        E(E<=0)=0.3;
        h = findall(f, 'type', 'image');
        [ver, dat] = version();
        t = strfind(ver, '.');ver = str2double(ver(1:t(2)-1));
        if ver >= 8.5
            %set(h, 'alphadata', E);
            alpha(h, E);
            %set(h, 'alphadata', E, 'AlphaDataMapping', 'scaled');
        else
            set(h, 'alphadata', E);
        end
        set(f, 'windowbuttonmotionfcn', '');
        set(f, 'windowbuttondownfcn', '');
    
    function savemask(varargin)
        handles = varargin{1};
        mask = evalin('base', 'mask');
        filename = get(handles.edmaskname, 'string');
        %[filename, pathname] = uiputfile('*.bmp', 'Save as');
        %if isequal(filename,0) || isequal(pathname,0)
        %    disp('User pressed cancel')
        %    return
        %else
            %imwrite(mask, fullfile(pathname, filename));
            imwrite(mask, fullfile(filename));
            pathname = pwd;
            disp(['Mask saved as ', fullfile(pathname, filename)])
        %end
        %imwrite(mask, 'mask.bmp')


% --- Executes on button press in pbinit.
function pbinit_Callback(hObject, eventdata, handles)
% hObject    handle to pbinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initiate


% --- Executes on button press in pb_load12IDBframe.
function pb_load12IDBframe_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load12IDBframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadSAXSframemask

% --- Executes on button press in pb_loadSAXSBS.
function pb_loadSAXSBS_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadSAXSBS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadSAXSBSmask

% --- Executes on button press in pb_loadCenterBS.
function pb_loadCenterBS_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadCenterBS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadSAXSCNTBSmask

% --- Executes on button press in pb_loadPilatusMask.
function pb_loadPilatusMask_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadPilatusMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadPilatusMask


% --- Executes on button press in pb_loadcoordinates.
function pb_loadcoordinates_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadcoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
loadCoordinates
