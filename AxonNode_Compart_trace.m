function U_trace = AxonNode_Compart_trace(t,U_diffvars,varargin)

   % make copies of the differential vars
   V_ext = U_diffvars(:,1);
   V_int = U_diffvars(:,2);
   h = U_diffvars(:,3);
   m = U_diffvars(:,4);
   p = U_diffvars(:,5);
   s = U_diffvars(:,6);
   narginchk(2+0,3);
   if (nargin >= 3)
       U_params = varargin{1};
   else
      U_params = struct();
   end

   %calculate the tracing vars we need
   %save the tracing vars
   U_trace = struct();
end
