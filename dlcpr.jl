
#using DataFrames, CSV
#filename = "/Users/matsuihiroshi/Desktop/dlcpr/chokiDeepCut_resnet50_jankenNov30shuffle1_1030000filtered.csv"
# cd  "/Users/matsuihiroshi/Desktop/dlcpr"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- #
# A function to read a dlc output in tidy style
function read_dlc(filename, fps=1)
    # read data
    d = DataFrame(CSV.File(filename, header=2, skipto=4));
    rename!(d, :bodyparts => :time);
    d.time = d.time * 1/fps; # 
    colnames = names(d);
    attach = repeat(["_x", "_y", "_likeli"], Int((length(colnames)-1)/3));
    
    # creating new column names
    newname = []
    for i in 2:length(colnames)
        push!(newname, string(split(colnames[i], "_")[1], attach[i-1]))
    end
    pushfirst!(newname, colnames[1])

    rename!(d, [names(d)[i] => new for (i, new) in enumerate(newname)])

    # attach filename column
    d[!,:filename] .= filename
    println(string("data process succeeded! file name : ", SubString(filename, 1, 45), "..." ))
    return d
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- #
# A function to read all dlc outputs in the current directory and combine them
function read_all()
    # get file names
    files = readdir()[occursin.(".csv", readdir())];
    d = read_dlc.(files)

    # add serial number
    for i in 1:length(d)
        d[i][!, :ser] .= i
    end

    d_ = d[1]
    for i in 2:length(d)
        d_ = [d_ ; d[i]]
    end

    println("#-----------------------------------------------------------------------------------------#")
    println("All processes have been done !")
    println("Now, your research can truely starts !")
    println("#-----------------------------------------------------------------------------------------#")

    return d_
end


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- #

