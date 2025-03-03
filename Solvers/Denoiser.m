function [ImgRec, res]= Denoiser(ImgNoise, ImgOrg, recMode, inPar)
res         = [];
% par         = ParSetDenoise(recMode);
nSig    = inPar.nSig; 
isShow  = inPar.isShow; 

switch recMode
   case 'BM3D'
        [res.PSNR, ImgRec] = BM3D(ImgOrg, ImgNoise, nSig );
        ImgRec = ImgRec * 255; 
    case 'WNNM'
        par     = ParSetWNNM(nSig);   
        par.step= 1; 
        ImgRec  = WNNM_DeNoising( ImgNoise, ImgOrg, par );         
    case 'GSRC'
        par     = ParSetGSRC (nSig, ImgOrg);
        par.nim = ImgNoise; 
        par.I   = ImgOrg; 
        ImgRec  = GSRC_Denoising( par, par.Thr);		
	case 'AST-NLS'
		ImgRec  = ast_nls( ImgNoise, nSig);	
        
	case 'MSEPLL'
		% models	
		par 	= ParSetMSEPLL(nSig);
		[ImgRec, res.PSNR] = denoise(ImgNoise/255, ImgOrg/255, par.models, par.betas, nSig, par.jmp, par.filters, par.weights);
		ImgRec 	= ImgRec * 255; 		
        
	case 'PGPD'
		[par, model]  	=  ParSetPGPD( nSig );
		par.I 			= ImgOrg/255; 
		par.nim 		= ImgNoise/255; 
		[ImgRec, res]  	=  PGPD_Denoising(par, model);		
        
	case 'SSC_GSM'
		if nSig < 50  	K = 3; 
        elseif nSig < 100 K = 4; 
		else 			K = 5;   end
		par 	= ParSetSSC( nSig, K);
		par.nim = ImgNoise; 
        par.I   = ImgOrg; 
		[ImgRec, res.PSNR, res.SSIM]   =    SSC_GSM_Denoising( par );    

	%% Deep learning based method
	case 'DnCNN'
		useGPU  = 0; 
		par 	= ParSetDnCNN(nSig, ImgNoise/255, useGPU);
		res 	= simplenn_matlab(par.net, par.input);
		
		if par.useGPU
			ImgRec = gather(ImgRec);
			Par.input  = gather(Par.input);
        end
        ImgRec 	= par.input - res(end).x;
        ImgRec  = ImgRec * 255; 
        
    case 'ACPT'
        ImgRec = ACPT(ImgNoise, nSig);     
    
	case 'ACVA' 
		wid = 128;
		step = 32;
		ImgRec = ACVA(ImgNoise,wid,step,nSig); %
		
    case 'TWSC'
        par          = ParSetTWSC(nSig);
        par.I 		 = ImgOrg/255; 
        [ImgRec, res] = Denoise_TWSC(ImgNoise/255, par);
        ImgRec       = ImgRec * 255; 
        
    case 'NCSR'
        par              =    ParSetNCSR( nSig );
        par.I            =    ImgOrg; 
        par.nim          =    ImgNoise;

        [ImgRec, res.PSNR, res.SSIM]   =    NCSR_Denoising( par ); 
        
    case 'GMM_EPLL'
        ImgRec  = ggmm_epll(ImgNoise/255, nSig/255, get_prior('gmm'));
        ImgRec       = ImgRec * 255; 
    case 'LMM_EPLL'
        ImgRec  = ggmm_epll(ImgNoise/255, nSig/255, get_prior('lmm'));
        ImgRec       = ImgRec * 255; 
    case 'GGMM_EPLL'
        ImgRec  = ggmm_epll(ImgNoise/255, nSig/255, get_prior('ggmm'));
        ImgRec       = ImgRec * 255; 
end