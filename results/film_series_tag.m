
% similarity matrix
%A = to_similarity(diff_tags,28);
A = A1;
A(A < 0.42) = 0;
L = laplacian_matrix(A,'unnormalized');
diff_matrix = diffusion_matrix(L,0.0085);
%1.8141e-04
%4.5354e-04
%forrest gump-2
%9,17,24 star wars original
%23, 283, 434 Matrix 
%64, 82, 113 LOTR
%33 96 426 godfather
%movieList = [2,9,17,24,23,283,434,64, 82,113,33,96,426];
%movie_classes = {[1],[2,3,4],[5,6,7],[8,9,10],[11,12,13]};

%categories
%29 mission impossible (1996(
%34- die hard with a vengeance 1995
%360-tomorrow never dies 1997

%12- toy story 1999
%22 Aladdin 1992
%461 Antz 1998
%31  lion king

%35 the sixth sense
%161 blair witch project
%200 scream


%movieList = [29,34,360,12,22,461,31,35,161,200];
%movie_classes = {[1,2,3],[4,5,6,7],[8,9,10]};

%action movies from 80s
%49 the terminator (1984)
%66 die hard (1988)
%277 Robocop (1987)
%313 Lethal weapon (1987)
%293 predator (1987)


%action movies from 2000s
%214 mission impossible 2 (2000)
%248 the bourne identity (2002)
%477 black hawk down
%290 Kill bill 2
%498 lethal weapon 3


movieList = [49,66,277,313,293,214,248,477,290,498];
movie_classes = {[1,2,3,4,5],[6,7,8,9,10]};



labels = num2str(movieList','%d');

%kids movies, time


distances = distance_matrix(diff_matrix, movieList);

md = mdscale(distances,2);
    
scatter(md(:,1),md(:,2),50,linspace(1,length(movieList),length(movieList)),'o', 'filled');
text(md(:,1), md(:,2), labels, 'horizontal','left', 'vertical','bottom')


figure;


%normalised stuff
L_norm = laplacian_matrix(A,'normalized');


diff_matrix_norm = diffusion_matrix(L_norm,1.5);


distances_norm = distance_matrix(diff_matrix_norm,movieList);
md_norm = mdscale(distances_norm,2);
scatter(md_norm(:,1),md_norm(:,2), 50,linspace(1,length(movieList),length(movieList)),'o', 'filled');

text(md_norm(:,1), md_norm(:,2), labels, 'horizontal','left', 'vertical','bottom')


ratio = mean_intraclass_dist(distances,movie_classes) / mean_interclass_dist(distances,movie_classes);

ratio_norm = mean_intraclass_dist(distances_norm,movie_classes) / mean_interclass_dist(distances_norm,movie_classes);








