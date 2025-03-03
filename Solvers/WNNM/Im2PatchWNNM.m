function  [Y, SigmaArr]  =  Im2Patch( E_Img,N_Img, par )
% Function image to patch and estimate local noise variance       
% + Input
%   - E_Img: current estimated image
%   - N_Img: received noisy image 
%   - par: parameter setting 
% + Output: 
%   - Y: image patch matrix
%   - SigmaArr: esimtaed local noise variance Array 

TotalPatNum = (size(E_Img,1)-par.patsize+1)*(size(E_Img,2)-par.patsize+1);                  %Total Patch Number in the image, no spacing between patch 
Y           =   zeros(par.patsize*par.patsize, TotalPatNum, 'single');                      %Current Patches, all patch matrix 
N_Y         =   zeros(par.patsize*par.patsize, TotalPatNum, 'single');                      %Patches in the original noisy image
k           =   0;

for i  = 1:par.patsize
    for j  = 1:par.patsize
              k     =  k+1;
        E_patch     =  E_Img(i:end-par.patsize+i,j:end-par.patsize+j);
        N_patch     =  N_Img(i:end-par.patsize+i,j:end-par.patsize+j);        
        Y(k,:)      =  E_patch(:)';
        N_Y(k,:)    =  N_patch(:)';
    end
end
 SigmaArr = par.lamada*sqrt(abs(repmat(par.nSig^2,1,size(Y,2))-mean((N_Y-Y).^2)));          %Estimated Local Noise Level