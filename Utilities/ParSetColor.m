function [par] = ParSetColor(recMode)
switch recMode
    case 'WNNM-YCrCb'
        par.note       = ''; 
    case 'WNNM-Ind'
        par.note       = ''; 
    case 'KQSVD'
        par.Reduce_DC   = 1;         par.bb     = 8; 
        par.step        = 2;         par.C      = 1.15;
        par.lambda = 0.037;          par.note        = '';
    case 'DVTV'
        par.order   = 1;        par.w     = 1;         
        par.maxiter = 300;      par.tau   = 0.95;
        par.note    = '';
    case 'DVTV_breg'
        par.order   = 1;        par.w     = 1; 
        par.maxiter = 300;      par.tau   = 0.95;
        par.note    = '';
    case 'DVTGV'
        par.order   = 2;        par.w     = 1; 
        par.maxiter = 300;      par.tau   = 0.95;
        par.note    = '';
    case 'DVTGV_breg' % need to develop
        par.order   = 2;        par.w     = 1;         
        par.maxiter = 300;      par.tau   = 0.95;
        par.note    = '';
    case 'CBM3D'        
        par.note    = '';
    case 'VTV'        
        par.note    = '';
    case 'TV_Breg'
        switch sigma
            case 0.1
                mu = 0.02;
            case 0.2
                mu = 0.018;
            case 0.3
                mu = 0.01;
            case 0.4
                mu = 0.005;
        end
        par.mu = mu; 
        par.tol = 0.01;     par.maxiter = 5;        
        par.note    = '';
    case 'WeitedTV_Breg'
        par.mu = 0.05; par.tol = 0.01; par.maxiter = 5;
        par.note    = '';        
    case 'NLTV_Breg'
        par.mu = 50; par.tol = 0.001; par.maxiter = 5; par.w = 0.5;
        par.note    = '';        
    case 'TV_Indept'
        switch sigma
            case 0.1
                mu = 0.02;
            case 0.2
                mu = 0.018;
            case 0.3
                mu = 0.01;
            case 0.4
                mu = 0.005;
        end
        par.mu = mu; par.tol     = 0.0001;        
        par.note    = '';
end;
par.note    = [recMode '_' par.note];
