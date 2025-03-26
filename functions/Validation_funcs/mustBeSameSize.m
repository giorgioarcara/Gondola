function mustBeSameSize(x,y)
%% mustBeSameSize Check if two inputs have the smae size

if any(size(x) ~=  size(y))
    error("Arguments must have the same size")
end

end