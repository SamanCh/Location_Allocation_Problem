clc
clear 
close all

a=zeros(20,2); %Customers' locations
d=zeros(20,1); %demands
s=zeros(4,1);
a(1,1)=28;
a(1,2)=42;
a(2,1)=18;
a(2,2)=50;
a(3,1)=74;
a(3,2)=34;
a(4,1)=74;
a(4,2)=6;
a(5,1)=70;
a(5,2)=18;
a(6,1)=72;
a(6,2)=98;
a(7,1)=60;
a(7,2)=50;
a(8,1)=36;
a(8,2)=40;
a(9,1)=12;
a(9,2)=4;
a(10,1)=18;
a(10,2)=20;
a(11,1)=14;
a(11,2)=78;
a(12,1)=90;
a(12,2)=36;
a(13,1)=78;
a(13,2)=20;
a(14,1)=24;
a(14,2)=52;
a(15,1)=54;
a(15,2)=6;
a(16,1)=62;
a(16,2)=60;
a(17,1)=98;
a(17,2)=14;
a(18,1)=36;
a(18,2)=58;
a(19,1)=38;
a(19,2)=88;
a(20,1)=32;
a(20,2)=54;

d(1,1)=15;
d(2,1)=14;
d(3,1)=14;
d(4,1)=18;
d(5,1)=23;
d(6,1)=25;
d(7,1)=14;
d(8,1)=14;
d(9,1)=15;
d(10,1)=24;
d(11,1)=15;
d(12,1)=14;
d(13,1)=15;
d(14,1)=13;
d(15,1)=14;
d(16,1)=14;
d(17,1)=14;
d(18,1)=13;
d(19,1)=13;
d(20,1)=26;

s(1,1)=80;
s(2,1)=90;
s(3,1)=100;
s(4,1)=100;

tmax=40;
Gen=100;
beta=0.25;
A=10;
g=100; %the upper bound of the certain area (0<(x,y)<100)
zm=10; %the upper bound of the the supplied amount (v<20)
I=size(s,1);%the number of facilites
J=size(d,1);%the number of customers
%%
tic
%%%%%%%%%%%%%%%%%%%% Simulated annealing %%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initializing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for i=1:I
        x(i)=rand*g;
        y(i)=rand*g;
    end
    u=0;
    l=0;
    %%%%%%%%%%%%%%%------objective function-------%%%%%%%%%%%%%%%%%
    for i=1:I
        for j=1:J
            z(i,j)=rand*zm;
            l=l+1;
            v(l)=z(i,j);
            minz(i,j) = z(i,j)*sqrt(((x(i)-a(j,1))^2)+((y(i)-a(j,2))^2));
            u=minz(i,j)+u;
        end
    end
    
    %%%%%%%%%%%%%%%----------constraints------------%%%%%%%%%%%%%%%
    demand=sum(z,1);
  
    %The amount supplied by each facility should not be more than the demand
    for j=1:J
        if demand(j)>d(j)
           penalty1(j)=(demand(j)-d(j))^10;
        else penalty1(j)=0;
        end
    end
    
    %The capacity of each facility
    capacity=sum(z,2);

    for i=1:I
        if capacity(i)>s(i) 
            penalty2(i)=(capacity(i)-s(i))^10;
        else penalty2(i)=0;
        end
    end
    fitness=u+sum(penalty1)+sum(penalty2);
    X(1,1:I)=x;
    X(1,I+1:2*I)=y;
    X(1,(2*I+1):(2*I+(I*J)))=v;
    X(1,(2*I+(I*J))+1)=fitness;
    
Xbest=X;
best=fitness;
%%%%%%%%%%%%%%%%%%%%% SA loops %%%%%%%%%%%%%%%%%%%%%%%%
count=0;
while count<500
for t=1:tmax
    for m=1:Gen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generating new solution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i=1:I
        x1(i)=rand*g;
        y1(i)=rand*g;
    end
    u1=0;
    l1=0;
    %%%%%%%%%%%%%%%------objective function-------%%%%%%%%%%%%%%%%%
    for i=1:I
        for j=1:J
            z1(i,j)=rand*zm;
            l1=l1+1;
            v1(l1)=z1(i,j);
            minz1(i,j) = z1(i,j)*sqrt(((x1(i)-a(j,1))^2)+((y1(i)-a(j,2))^2));
            u1=minz1(i,j)+u1;
        end
    end
    
    %%%%%%%%%%%%%%%----------constraints------------%%%%%%%%%%%%%%%
    demand1=sum(z1,1);
  
    %The amount supplied by each facility should not be more than the demand
    for j=1:J
        if demand1(j)>d(j)
           penalty11(j)=(demand1(j)-d(j))^10;
        else penalty11(j)=0;
        end
    end
    
    %The capacity of each facility
    capacity1=sum(z1,2);

    for i=1:I
        if capacity1(i)>s(i) 
            penalty12(i)=(capacity1(i)-s(i))^10;
        else penalty12(i)=0;
        end
    end
    fitness1=u1+sum(penalty11)+sum(penalty12);
    Xnew(1,1:I)=x1;
    Xnew(1,I+1:2*I)=y1;
    Xnew(1,(2*I+1):(2*I+(I*J)))=v1;
    Xnew(1,(2*I+(I*J))+1)=fitness1;

    Delta=fitness1-fitness;
    Z=exp((-Delta)/A);
    if Delta<0
        Xbest=Xnew;
        X=Xnew;
        fitness=fitness1;
    elseif Z>rand
        X=Xnew;
    end
    end
    A=A-beta*A;
end
count=count+1;
B(count,1)=fitness;
Y(count,1)=count;
end

   
%%                   End of for loop generation 
%%  
best=Xbest((I*2)+((I*J)+1))
optimal_location=Xbest(1:2*I)


%                    Disply Convergency Chart
           plot(Y,B)
           title('Convergency Chart' )
           xlabel('Number of Iteration')
           ylabel('Objective function Value')
           hold on
           grid on
           toc
