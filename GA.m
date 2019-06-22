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


pop=100;
Gen=1000;
Pc=0.6;
g=100; %the upper bound of the certain area (0<(x,y)<100)
zm=10; %the upper bound of the the supplied amount (v<20)
I=size(s,1);%the number of facilites
J=size(d,1);%the number of customers
%%
tic
%%%%%%%%%%%%%%%%%%Genetic Algorithm%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initializing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for m=1:pop
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
    chromosomes(m,1:I)=x;
    chromosomes(m,I+1:2*I)=y;
    chromosomes(m,(2*I+1):(2*I+(I*J)))=v;
    chromosomes(m,(2*I+(I*J))+1)=fitness;
    
end
[fit,k]=sort(chromosomes(:,(2*I+(I*J))+1));
best=fit(1);
bestchrom=chromosomes(k(1),:);
%%%%%%%%%%%%%%%%  Selection strategy (tournoment method)  %%%%%%%%%%%%%%%%
for t=1:Gen
    [fit,k]=sort(chromosomes(:,(2*I+(I*J))+1));
    best1=fit(1);
    if best1<best
        best=best1;
        bestchrom=chromosomes(k(1),:);
    end
for m=1:pop
    r1=randi([1,pop]);
    r2=randi([1,pop]); %#ok<*REMFF1>
    while r1==r2
         r1=randi([1,pop]);
         r2=randi([1,pop]);
    end
    if(chromosomes(r1,(2*I+(I*J))+1)>chromosomes(r2,(2*I+(I*J))+1))
        chro(m,:)=chromosomes(r2,:);
    else chro(m,:)=chromosomes(r1,:);
    end
end

%%%%%%%%%%%%%%% Crossover operator %%%%%%%%%%%%%%%%%%
    b=0;
    for m=1:pop
        r=rand;
        if r<Pc
            b=b+1;
            d1=randi([1,pop]);
            d2=randi(1,1,[1,pop]);
            while d1==d2
                 d1=randi([1,pop]);
                 d2=randi([1,pop]);
            end
            parent1=chro(d1,:);
            parent2=chro(d2,:);
            landa=rand;
            child1=parent1*landa+parent2*(1-landa);
            child2=parent1*(1-landa)+parent2*landa;
            for i=1:I*2
                if 0>child1(i)>zm
                   child1(i)=rand*zm;
                end
                if 0>child2(i)>zm
                   child2(i)=rand*zm;
                end
            end
            for j=2*I+1:(2*I+I*J)
                if 0>child1(j)>g
                    child1(j)=rand*g;
                end
                if 0>child2(j)>g
                    child2(j)=rand*g;
                end
            end
            e=0;
            minz1=zeros(I,J);
            minz2=zeros(I,J);
            for i=1:I
                x1(i)=child1(i);
                y1(i)=child1(I+i);
                x2(i)=child2(i);
                y2(i)=child2(I+i);
                for j=1:J
                    e=e+1;
                    z1(i,j)=child1(2*I+e);
                    z2(i,j)=child2(2*I+e);
                    minz1(i,j)=z1(i,j)*sqrt(((x1(i)-a(j,1))^2)+((y1(i)-a(j,2))^2));
                    minz2(i,j)=z2(i,j)*sqrt(((x2(i)-a(j,1))^2)+((y2(i)-a(j,2))^2));
                end           
            end
            %%%%%%%%%%%%%%%----------constraints------------%%%%%%%%%%%%%%%
            demand1=sum(z1,1);
            demand2=sum(z2,1);
            %The amount supplied by each facility should not be more than the demand
            for j=1:J
               if demand1(j)>d(j)
                  penalty11(j)=(demand1(j)-d(j))^10;
               else penalty11(j)=0;
               end
               if demand2(j)>d(j)
                  penalty12(j)=(demand2(j)-d(j))^10;
               else penalty12(j)=0;
               end
            end
    
            %The capacity of each facility
            capacity1=sum(z1,2);
            capacity2=sum(z2,2);
            
            for i=1:I
               if capacity1(i)>s(i) 
                  penalty21(i)=(capacity1(i)-s(i))^10;
               else penalty21(i)=0;
               end
               if capacity2(i)>s(i) 
                  penalty22(i)=(capacity2(i)-s(i))^10;
               else penalty22(i)=0;
               end
            end
            fitness1=sum(sum(minz1))+sum(penalty11)+sum(penalty12)+sum(penalty21)+sum(penalty22);
            fitness2=sum(sum(minz2));
            child1(I*2+I*J+1)=fitness1;
            child2(I*2+I*J+1)=fitness2;
            chrom1(b,:)=child1;
            chrom1(b+1,:)=child2;
            
        %%%%%%%%%%%%%%%%%%----- Mutation operator ----%%%%%%%%%%%%%%%%%
        else 
            b=b+1;
            r3=randi([1,pop]);
            o1=randi([1,I]); %for x
            o2=randi([I+1,2*I]); %for y
            o3=randi([(2*I)+1,(2*I)+(I*J)]);%for z
            chro(r3,o1)=rand*g;
            chro(r3,o2)=rand*g;
            chro(r3,o3)=rand*zm;
            chrom1(b,:)=chro(r3,:);
            p=0;
            minz1=zeros(I,J);
            for i=1:I
                x3(i)=chrom1(b,i);
                y3(i)=chrom1(b,I+i);
                for j=1:J
                    p=p+1;
                    z3(i,j)=chrom1(b,2*I+p);
                    minz3(i,j)=z3(i,j)*sqrt(((x3(i)-a(j,1))^2)+((y3(i)-a(j,2))^2));             
                end           
            end
            %%%%%%%%%%%%%%%----------constraints------------%%%%%%%%%%%%%%%
            demand3=sum(z3,1);
  
            %The amount supplied by each facility should not be more than the demand
            for j=1:J
               if demand3(j)>d(j)
                  penalty13(j)=(demand3(j)-d(j))^10;
               else penalty13(j)=0;
               end
            end
    
            %The capacity of each facility
            capacity3=sum(z3,2);

            for i=1:I
               if capacity3(i)>s(i) 
                  penalty23(i)=(capacity3(i)-s(i))^10;
               else penalty23(i)=0;
               end
            end
            fitness3=sum(sum(minz3))+sum(penalty13)+sum(penalty23);
            chrom1(b,(I*2+I*J)+1)=fitness3;
    end
    end
    D=size(chrom1,1);
    if D>pop
        chrom1(pop+1:D,:)=[];
    end
   chromosomes=chrom1;
   B(t,1)=best;
   Y(t,1)=t;
end
%%                   End of for loop generation 
%%  
best
opt_location=bestchrom(1:I*2)

%                    Disply Convergency Chart
           plot(Y,B)
           title('Convergency Chart' )
           xlabel('Number of Iteration')
           ylabel('Objective function Value')
           hold on
           grid on
           toc
