function bcm=connmatrixreformat(BEDPOSTXpathAtlasFolderPath)

%function connmatrixreformat(fslmatrix)
%
%Reformat the probtrackx matrix results to a connectivity matrix. The
%format used here is able to be applied to quantitative graph theory
%measurements.
%
% Input:
%BEDPOSTXpathAtlasFolderPath     = The BEDPOSTX path where were used in the
%BrainConnMatrix tool and has the brian atlas used in the connectivity
%evaluation.
% 
% Output:
%bcm              = The brain connectivity matrix resulted from the BEDPOSTX reformating data. This
%represents the connectivity of the seed as a whole.


% Get folders name
folders=dir(fullfile(BEDPOSTXpathAtlasFolderPath,'*BrainConn'));

% Spliting the input filename to get path, filename and extention
% [path, filename, ext] = fileparts(fslmatrix);

directoryNames = {folders([folders.isdir]).name};

rAux=1;
for i=1:length(directoryNames)
  directoryNames{i}

  % Load file
    data=load(strcat(BEDPOSTXpathAtlasFolderPath,'/',directoryNames{i},'/fdt_matrix2.dot'));
    lsize=size(data);
    if(lsize(1)~=1)
        
    % Create full matrix from data
    matrix=full(spconvert(data));

    % Reformating the rows values to build one single row (all connectivity from the ROI)
    m_size=size(matrix);

    conn_sum=zeros(1,m_size(2));
    if(rAux==1)
        connMatrix=zeros(1,m_size(2));
    end
    aux=0;
    for col=1:m_size(2)
        for row=1:m_size(1)    
            aux = aux + matrix(row,col);
        end
        conn_sum(1,col)=aux;
        aux=0;
    end
    if(rAux==1)
        connMatrix=conn_sum;
    else
        connMatrix=vertcat(connMatrix,conn_sum);
    end
    rAux=rAux+1;
    else
        connMatrix=vertcat(connMatrix,zeros(1,m_size(2)));
    end
end

% Output the final connectivity matrix
bcm=connMatrix*connMatrix';

% Removing self correlation
for x=1:length(bcm)
    for y=1:length(bcm)
        if(x==y)
            bcm(x,y)=0;
        end
    end
end