clear all; clc; tic;

% %Input Data,distance matrix and fitness matrix
data=load('G:\MSc\Thesis\data\new1\EUD2D\wi29.tsp');
d=[data(:,2) data(:,3)];
[data_n,in_n] = size(d);
[DM,FM]=DistM(d);

%Initial population creation
%fuzzy C means clusterring 
%number of cluster and population
nc=10;
nump=100;  
[BRoute]=CRTD(d,nc,nump);
%random population create
%     for xij=1:nump
%         BRoute(xij,:)=randperm(data_n);
%     end
ctrroute=BRoute;
[X12,Y12]=size(BRoute);
   
%Initialization of popualtion formation and results
Rlgth=RouteFitness(DM,BRoute);
[X,idx]=sort(Rlgth,'ascend');         
%  for ii=1:X12
     BRoute((1:X12),:)=BRoute(idx(1:X12),:);
%  end
 toc
%Genetic Algorithm 
BestSolfar=X(1);
BestRoutefar=BRoute(1,:);
mutationProb=.03;
gen=1500;

for i=1:gen
    NRoutes=GAFIB(DM,BRoute,mutationProb);
    Rlgth1=RouteFitness(DM,NRoutes);
    [X1,idx1]=sort(Rlgth1,'ascend');
    Newsol=X1(1);
    BRoute(1,:)=NRoutes(idx1(1),:);
    NRoutes(idx1(1),:)=[];
    for iji=2:X12
        BRoute(iji,:)=NRoutes(iji-1,:);
    end
    if Newsol<BestSolfar
        BestSolfar=Newsol;
        BestRoutefar=BRoute(1,:);
        visualizeGeneration( d.', BRoute, X1(1), Rlgth1 )
    end
     minPathes(i)=BestSolfar;
end

figure(2) 
plot(minPathes, 'MarkerFaceColor', 'blue','LineWidth',2);
title('Minimum Path Length for Iteration');
% set(gca,'ytick',500:100:5000); 
ylabel('Path Length');
xlabel('Iteration Number');
grid on   

BestRoutefar=[BestRoutefar BestRoutefar(1,1)];
format bank
BestSolution=BestSolfar  
AverageRouteFitness=(sum(X1)/length(X1))
WorstRouteFitness=X1(length(X1))
toc;

