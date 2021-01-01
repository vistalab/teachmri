function spins = kspaceGetCurrentBasisFunctions(spins)
 % update the spins to account for the most recent step
 %
 % spins = kspaceGetCurrentBasisFunctions(spins)

if ~isfield(spins, 'total') 
    % if this is the first data acquisition
    spins.total = spins.step;
else
    spins.total = spins.total .* spins.step; 
end
