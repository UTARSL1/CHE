function out = JND(T0,gamma)

out(1:128) = T0.*(1-((0:127)./127).^0.5)+3;
out(129:256) = gamma.*((128:255)-127)+3;
