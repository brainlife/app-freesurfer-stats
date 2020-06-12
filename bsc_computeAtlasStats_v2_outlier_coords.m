function [atlasGeometryStats] =bsc_computeAtlasStats_v2_outlier_coords(atlas)
% [atlasGeometryStats] =bsc_computeAtlasStats_v2(atlas)
%
% This function computes three primary groups of geometric stats: 
%  (1) volume based (i.e. actual volume and total brain proportion)
%  (2) centroid based
%  (3) boundary based (i.e. the 3D bounding box coordinates for each roi)
%
% Inputs:
% -wbfg: a whole brain fiber group structure
% -atlas: path to an atlas or an atlas object itself
% -categoryClassification: the classification structure resulting from the
% classification segmentation.  Done outside of this function to avoid
% doing it repeatedly

% Outputs:
% -atlasGeometryStats:  A table with relevant parcel data for this atlas

% (C) Daniel Bullock, 2020, Indiana University
%%
if ischar(atlas)
    %load the atlas if its a path
    atlas=niftiRead(atlas);
else
    %do nothing
end
%
% find all of the unique labels in the atlas
% And remove zero
uniqueLables=unique(atlas.data);
%if you want to be agnostic about which label is actually the background ,
%you could just find whichever label is the most common, and exclude that.
uniqueNoZero = uniqueLables(find(uniqueLables~=0));
%
%  Create an roi for all of these ROIS (to do a computation of whole brain
%  volume
%  NOTE:  YOU PROBABLY WANT TO EXCLUDE SOME OF THESE ROIS, BUT WE CAN TAKE
%  CARE OF THAT IN A LATER VERSION
[wholeBrainRoi] =bsc_roiFromAtlasNums(atlas,uniqueNoZero',1);
%kind of like a proxy for whole brain volume, except the units her are kind
%of ambiguous.  When you devide a roi's coordinate number by this, the
%units cancel out and you get the appropriate proportion.
wholeBrainCoordNumber=length(wholeBrainRoi.coords);

%set the column names for the table now
columnNames={'ROI_name','actual_vol','BrainVol_proportion','centroid_x','centroid_y','centroid_z','medialBorder','lateralBorder','anteriorBorder','posteriorBorder','superiorBorder','inferiorBorder','boxyness','outlierCoords'};
%createROINameVec

tableData=cell([length(uniqueNoZero),length(columnNames)]);

%now loop over the rois
for iROIs=1:length(uniqueNoZero)
    %extract current ROI
    [currentROI] =bsc_roiFromAtlasNums(atlas,uniqueNoZero(iROIs),1);
    %creat current roi name for table
    currentName=strcat('ROI_',currentROI.name);
    
    if round(str2double(currentROI.name),-3) == 11000
        coordsInd=find(currentROI.coords(:,1)>0);
        outlierCoords=currentROI.coords(coordsInd,:);
    else
        coordsInd=find(currentROI.coords(:,1)<0);
        outlierCoords=currentROI.coords(coordsInd,:);
    end
    
    %compute whole brain proportion
    wholeBrainProportion=length(currentROI.coords)/wholeBrainCoordNumber;
    
    %each roi coord is taken from an image space voxel, as such, you need
    %to take into account the voxel dim in order to get the roi volume
    actualVol=length(currentROI.coords)*prod(atlas.pixdim);
    
    computeCentroid=mean(currentROI.coords,1);
    centroidx=computeCentroid(1);
    centroidy=computeCentroid(2);
    centroidz=computeCentroid(3);
    
    %begin computing the borders
    medialBorder=bsc_planeFromROI_v2(currentROI,'medial',atlas);
    lateralBorder=bsc_planeFromROI_v2(currentROI,'lateral',atlas);
    anteriorBorder=bsc_planeFromROI_v2(currentROI,'anterior',atlas);
    posteriorBorder=bsc_planeFromROI_v2(currentROI,'posterior',atlas);
    superiorBorder=bsc_planeFromROI_v2(currentROI,'superior',atlas);
    inferiorBorder=bsc_planeFromROI_v2(currentROI,'inferior',atlas);
    
    %count the occurances of numbers in the roi.  The most common one
    %should be the unchanging one, i.e. the planar component.
    [counts, labels]=groupcounts(reshape(medialBorder.coords,numel(medialBorder.coords),1));
    
    %find the number corresponding to the most common number, this is the
    %border
    medialBorderCoord=labels(find(max(counts)==counts));
    
    [counts, labels]=groupcounts(reshape(lateralBorder.coords,numel(lateralBorder.coords),1));
    lateralBorderCoord=labels(find(max(counts)==counts));
    
    [counts, labels]=groupcounts(reshape(anteriorBorder.coords,numel(anteriorBorder.coords),1));
    anteriorBorderCoord=labels(find(max(counts)==counts));
    
    [counts, labels]=groupcounts(reshape(posteriorBorder.coords,numel(posteriorBorder.coords),1));
    posteriorBorderCoord=labels(find(max(counts)==counts));
    
    [counts, labels]=groupcounts(reshape(superiorBorder.coords,numel(superiorBorder.coords),1));
    superiorBorderCoord=labels(find(max(counts)==counts));
    
    [counts, labels]=groupcounts(reshape(inferiorBorder.coords,numel(inferiorBorder.coords),1));
    inferiorBorderCoord=labels(find(max(counts)==counts));
    
    %compute the "boxyness" of the roi.  The "boxyness" is the ratio of the
    %roi's volume to the volume of the box bounded by it's borders.  In the
    %event that a particular roi has an extreme island value (a voxel that
    %is detached from he main body and far removed from the main body of
    %the roi) this value will be uniquely low relative to the "normal"
    %(i.e. group mean) value for this measure.
    %note:  you could get a senario where both values are negative (i.e.
    %left side of brain, both borders posterior anterior comisure,etc),
    %hence the need for abs.
    
    boxyness=actualVol/[abs(lateralBorderCoord-medialBorderCoord)*abs(anteriorBorderCoord-posteriorBorderCoord)*abs(superiorBorderCoord-inferiorBorderCoord)];
    
    %transparancy
    tableData{iROIs,1}=currentName;
    tableData{iROIs,2}=actualVol;
    tableData{iROIs,3}=wholeBrainProportion;
    tableData{iROIs,4}=centroidx;
    tableData{iROIs,5}=centroidy;
    tableData{iROIs,6}=centroidz;
    tableData{iROIs,7}=medialBorderCoord;
    tableData{iROIs,8}=lateralBorderCoord;
    tableData{iROIs,9}=anteriorBorderCoord;
    tableData{iROIs,10}=posteriorBorderCoord;
    tableData{iROIs,11}=superiorBorderCoord;
    tableData{iROIs,12}=inferiorBorderCoord;
    tableData{iROIs,13}=boxyness;
    tableData{iROIs,14}=outlierCoords;
    
end

%set it in a table
atlasGeometryStats=cell2table(tableData,'VariableNames',columnNames);
 
end
