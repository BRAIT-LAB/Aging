load("Cuba90.mat");
j=3;
k=1;
%Cuba90=num2cell(Cuba90);
for i=1:198
    if Cuba90{i,1}==Cuba90{i+1,1};
        Cuba90{k,j}=Cuba90{i,2};
        k=k+1;
    else
        Cuba90{k,j}=Cuba90{i,2};
        k=1;
        j=j+1;
    end
end
sum=Cuba90{1,3};
m=1;
k=0;
for i=1:198
    if Cuba90{i,1}==Cuba90{i+1,1};
        sum=sum+Cuba90{i+1,3};
    else
      aver=sum/(i-k);
      Cuba90{m,4}=Cuba90{i,1};
      Cuba90{m,6}=aver;
      sum=Cuba90{i+1,3};
      m=m+1;
       k=i;
    end
end

