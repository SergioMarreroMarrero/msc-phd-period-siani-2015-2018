function parameterNames=stringNodesGenerate(points)

parameterNames=cell(1,numel(points));
for i=1:numel(parameterNames)
    parameterNames{i}=sprintf('LINE%d_VI_vs_Time',points(i));
end

end