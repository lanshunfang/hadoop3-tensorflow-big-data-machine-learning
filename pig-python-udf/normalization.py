# https://pig.apache.org/docs/r0.17.0/udf.html#python-udfs
# https://pig.apache.org/docs/r0.17.0/basic.html



# grunt> register 'normalization.py' using streaming_python as normalization;
# grunt> raw_data = LOAD 'hdfs://localhost:9000/**' USING PigStorage(',') 
# grunt> data_group_all = Group raw_data All;
# grunt> means = foreach data_group_all generate normalization.get_means(all_rows);
# grunt> stds = foreach data_group_all generate normalization.get_stds(all_rows, means);

from pig_util import outputSchema

'''
 @outputSchema("y:bag{t:tuple(len:int,word:chararray)}") 
 def collectBag(bag):
   outBag = []
   for word in bag:
     tup=(len(bag), word[1])
     outBag.append(tup)
   return outBag
'''

means = {}
sums = {}
count = {}

@outputSchema('means:map[double]')
def get_means(all_rows):
    # outBag = []
    global sums
    global count
    global means
    row_len = len(all_rows[0])
    for idx, itm in enumerate(all_rows):
        if len(item) != row_len:
            continue
        sums[idx] = sums[idx] if sums[idx] != None else 0
        sums[idx] = sums[idx] + itm
        count[idx] = count[idx] if count[idx] != None else 0
        count[idx] = count[idx] + 1
        # outBag.append(tup)

    for idx, itm in enumerate(sums):
        means[idx] = means[idx] if means[idx] != None else 0
        means[idx] = itm / count[idx]

    return means
    