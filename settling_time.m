function t_settled = settling_time(t, y, target, tolerance)
    % The function returns the value of t after which the signal y stays
    % within a percentage of the target set by the tolerance argument
    
    % Make sure inputs are row vectors
    if iscolumn(t)
        t = t';
    end
    if iscolumn(y)
        y = y';
    end
    
    % Calculate treshold
    error = y-target;
    treshold = tolerance*target;

    % Check when error is within the treshold
    within_treshold = abs(error) <= treshold;

    % Search for when the signal stays within the treshold
    settled = logical(cumprod(within_treshold, 'reverse'));
    
    % Find the t where signal first becomes settled
    if any(settled)
        t_settled = t(logical(diff([false settled])));
    else
        t_settled = Inf;
end

