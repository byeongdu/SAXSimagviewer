function res = gf_readini(inifile)
% Byeongdu Lee
% 2007

fid = fopen(inifile, 'r');
if fid==-1
	delete(hmf_ctrl);
	errordlg(['Initialization file ' inifile ' not found'],'MFit : Error');
	
end

%----- Set up tag names for registry section -----------------------------
gifit_ver = 1.0;
disp([ 'Welcome to GiFit ' gifit_ver ]);

disp(['gifit reading ' inifile ' file'])
drawnow
%----- Read line by line to end of .ini file ------------------------------------------
line=fgetl(fid);		      								
loadFile={}; loadDir={}; loadName={};
FqFile={}; FqDir={}; FqName={};
SqFile={}; SqDir={}; SqName={};
CTFile={}; CTDir={}; CTName={};
fitfFile={}; fitfDir={}; fitfName={};


while ~any(line==-1) 

%-- Read to beginning of section (contains '{')
	while ~any(line==-1) & isempty(findstr(line,'{')) 
		line=fgetl(fid); 
	end

%-- Get name of section
	Section=lower(strtok(line,'{}'));
    if Section == -1
        break;
    end
	line=fgetl(fid);
	disp(['Reading ' Section ' section...'])
	drawnow

%----- {General} section has lines 'property = value'------------------------
	if ~isempty(findstr(Section,'general'))
	
		while ~any(line==-1) & isempty(findstr(line,'{'))
			[Name s]=strtok(line,'=');							% Property name
			Value=s(2:length(s));									% Property value
			if ~isempty(Value) & (line(1)~= '%')
				Name=Name(~isspace(Name));
  		    		Value=deblank(fliplr(deblank(fliplr(Value))));
			end
			line=fgetl(fid);
		end

%----- {Startup} section has lines to be sent to 'mf_batch' ------------------------

%----- Registry sections have entries of the form 'm-file name, path, description'-----
	elseif ~isempty(findstr(Section, 'load routines'))

                while line~=-1 & isempty(findstr(line,'{'))
					[ff s]=strtok(line,','); ff=ff(~isspace(ff));     % Get m-file name
					[dd s]=strtok(s,','); dd=dd(~isspace(dd));	     % Get path
					nn=strtok(s,','); 	                             % Get description
                  if isempty(nn)                                    % It's a separator... 
                      Sep='on';
			      elseif (line(1) ~= '%')                          % It's a registry line, not a comment
                    loadFile = [loadFile, ff];	                       % Array of filenames 
                    loadDir = [loadDir, dd];                          % Array of dir names 
                    nn=deblank(fliplr(deblank(fliplr(nn))));       % Array of descriptions
                    loadName = [loadName, nn];
                  end
					
                    line=fgetl(fid);
                end
	elseif ~isempty(findstr(Section, 'fit functions'))

                while line~=-1 & isempty(findstr(line,'{'))
					[ff s]=strtok(line,','); ff=ff(~isspace(ff));     % Get m-file name
					[dd s]=strtok(s,','); dd=dd(~isspace(dd));	     % Get path
					nn=strtok(s,','); 	                             % Get description
                  if isempty(nn)                                    % It's a separator... 
                      Sep='on';
			      elseif (line(1) ~= '%')                          % It's a registry line, not a comment
                    fitfFile = [fitfFile, ff];	                       % Array of filenames 
                    fitfDir = [fitfDir, dd];                          % Array of dir names 
                    nn=deblank(fliplr(deblank(fliplr(nn))));       % Array of descriptions
                    fitfName = [fitfName, nn];
                  end
					
                    line=fgetl(fid);
                end
	elseif ~isempty(findstr(Section, 'fq functions'))

                while line~=-1 & isempty(findstr(line,'{'))
					[ff s]=strtok(line,','); ff=ff(~isspace(ff));     % Get m-file name
					[dd s]=strtok(s,','); dd=dd(~isspace(dd));	     % Get path
					nn=strtok(s,','); 	                             % Get description
                  if isempty(nn)                                    % It's a separator... 
                      Sep='on';
			      elseif (line(1) ~= '%')                          % It's a registry line, not a comment
                    FqFile = [FqFile, ff];	                       % Array of filenames 
                    FqDir = [FqDir, dd];                          % Array of dir names 
                    nn=deblank(fliplr(deblank(fliplr(nn))));       % Array of descriptions
                    FqName = [FqName, nn];
                  end
					
                    line=fgetl(fid);
                end
	elseif ~isempty(findstr(Section, 'sq functions'))
        disp('---------------------')

                while line~=-1 & isempty(findstr(line,'{'))
					[ff s]=strtok(line,','); ff=ff(~isspace(ff));     % Get m-file name
					[dd s]=strtok(s,','); dd=dd(~isspace(dd));	     % Get path
					nn=strtok(s,','); 	                             % Get description
                  if isempty(nn)                                    % It's a separator... 
                      Sep='on';
			      elseif (line(1) ~= '%')                          % It's a registry line, not a comment
                    SqFile = [SqFile, ff];	                       % Array of filenames 
                    SqDir = [SqDir, dd];                          % Array of dir names 
                    nn=deblank(fliplr(deblank(fliplr(nn))));       % Array of descriptions
                    SqName = [SqName, nn];
                  end
					
                    line=fgetl(fid);
                end
	elseif ~isempty(findstr(Section, 'ct functions'))
                while line~=-1 & isempty(findstr(line,'{'))
					[ff s]=strtok(line,','); ff=ff(~isspace(ff));     % Get m-file name
					[dd s]=strtok(s,','); dd=dd(~isspace(dd));	     % Get path
					nn=strtok(s,','); 	                             % Get description
                  if isempty(nn)                                    % It's a separator... 
                      Sep='on';
			      elseif (line(1) ~= '%')                          % It's a registry line, not a comment
                    CTFile = [CTFile, ff];	                       % Array of filenames 
                    CTDir = [CTDir, dd];                          % Array of dir names 
                    nn=deblank(fliplr(deblank(fliplr(nn))));       % Array of descriptions
                    CTName = [CTName, nn];
                  end
					
                    line=fgetl(fid);
                end
    end
%    line=fgetl(fid);
end

fclose(fid);
res.loadFile=loadFile; res.loadDir=loadDir; res.loadName=loadName;
res.FqFile=FqFile; res.FqDir=FqDir; res.FqName=FqName;
res.SqFile=SqFile; res.SqDir=SqDir; res.SqName=SqName;
res.CTFile=CTFile; res.CTDir=CTDir; res.CTName=CTName;
res.fitfFile=fitfFile; res.fitfDir=fitfDir; res.fitfName=fitfName;