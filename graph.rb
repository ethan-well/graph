# 将图转为矩阵
def init_graph
  graup_arr = create_arr(5, 5) 
  ARGV[0].split(",").each do |route|
    start_place = char_to_int(route[0]).to_i
    end_place = char_to_int(route[1]).to_i
    dist = route[2].to_i
    
    graup_arr[start_place][end_place] = dist  
  end
  $group_arr = graup_arr
end

def char_to_int(a)
    table = ("A".."E").to_a
    return table.index(a)
end

def create_arr(width,height)
    arr = Array.new(width)
    arr.map! { Array.new(height) }
    return arr
end

def route_distance(route)
  begin
    distance = 0
    for i in 0..route.length-2
      start_place = char_to_int(route[i]).to_i
      end_place = char_to_int(route[i+1]).to_i
      distance += $group_arr[start_place][end_place]
    end
    return distance
  rescue
    return "NO SUCH ROUTE"
  end
end

#1 The distance of the route A-B-C
def abc_distance
  route_distance(["A","B","C"])
end

#2 The distance of the route A-D
def ad_distance
  route_distance(["A","D"])
end

#3 The distance of the route A-D-C
def adc_distance
  route_distance(["A","D","C"])
end

#4 The distance of the route A-E-B-C-D
def aebcd_distance
  route_distance(["A","E","B","C","D"])
end

#5 The distance of the route A-E-D
def aed_distance
  route_distance(["A","E","D"])
end

# 广度优先搜索,进行指定深度的搜索
def next_station(path, count, answers)
  if count == 0                                                            #达到要求的搜索深度
    answers.push(path)
    return answers                                                         #递归调用: 当搜索深度到达要求深度之后，返回到上次调用
  end
  count = count - 1
  current_station = path.last 
  next_stations = $group_arr[current_station].each_index.select{|i| $group_arr[current_station][i] != nil}
  next_stations.each do |station|
    curr_path = path + [station]
    next_station(curr_path, count, answers)
  end
  
  answers
end

#6 the number of trips starting at C and ending at C with a maximum of 3 stops
def trips_number_c_to_c
  paths = next_station([2], 3, [])                                        #搜索所有从C开始的，深度不超过3的所有路径
  valid_paths = []
  paths.each do |path|                                                    #从'以C开始的，深度不超过3的所有路径'中找出终点为C的路径
    c_station_index = path.each_index.select{|i| (path[i] == 2 && i>0) }
    c_station_index.each do |index|                                       #每个路径里可能包含多个有效路径子段
      valid_paths = valid_paths.push(path[0, index.to_i+1])               #以C开始到C结束的路径
    end
  end

  valid_paths = valid_paths.uniq.reject { |p| p.empty? }
  
  return valid_paths.length
end

#7 the number of trips starting at A and ending at C with exactly 4 stops
def  a_to_c_4stops
  paths = next_station([0], 4, [])  
  valid_paths = []
  paths.each do |path|
    c_station_index = path.each_index.select{|i| (path[i] == 2 && i==4) }
    valid_paths = valid_paths.push(path[0, c_station_index.last.to_i])   #因为stops必须是4,所以每个路径中最多包含一个有效路径子段
  end
  valid_paths = valid_paths.uniq.reject { |c| c.empty? }
  return valid_paths.length
end

def path_length(path)
  length = 0  
  begin
    for i in 0..path.length-2
      start_place = path[i].to_i
      end_place = path[i+1].to_i
      length += $group_arr[start_place][end_place]
    end
    return length
  rescue
    return "NO SUCH ROUTE"
  end
end

#8 The length of the shortest route (in terms of distance to travel) from A to C
def shortest_route_a_to_c
  paths = next_station([0], 5, [])
  valid_paths = []
  paths.each do |path|
    c_station_index = path.each_index.select{|i| (path[i] == 2 && i>0) }
    c_station_index.each do |index|
      valid_paths = valid_paths.push(path[0, index.to_i+1])                          #以A开始到C结束的路径
    end
  end

  valid_paths = valid_paths.uniq.reject { |c| c.empty? }
  dists = []
  valid_paths.each do |path|
    dists.push(path_length(path))
  end
  
  return dists.sort[0]
end

#9 The length of the shortest route (in terms of distance to travel) from B to B
def shortest_route_b_to_b
  paths = next_station([1], 5, [])
  valid_paths = []
  paths.each do |path|
    c_station_index = path.each_index.select{|i| (path[i] == 1 && i>0) }
    c_station_index.each do |index|
      valid_paths = valid_paths.push(path[0, index.to_i+1])                         #以B开始到B结束的路径
    end
  end

  valid_paths = valid_paths.uniq.reject { |c| c.empty? }
  dists = []
  valid_paths.each do |path|
    dists.push(path_length(path))
  end
  return dists.sort[0]
end

def routes_less30_num_c_to_c
  paths = next_station([2], 10, [])
  valid_paths = []
  paths.each do |path|
    c_station_index = path.each_index.select{|i| (path[i] == 1 && i>0) }
    c_station_index.each do |index|
      valid_paths = valid_paths.push(path[0, index.to_i+1])                          #以C开始到C结束的路径
    end
  end

  valid_paths = valid_paths.uniq.reject { |c| c.empty? }
  dists = []
  valid_paths.each do |path|
    dists.push(path_length(path))
  end
  routes_num = dists.select {|item| item < 30 }.count
  return routes_num
end


#将图的问题转为矩阵求解
init_graph

p abc_distance
p ad_distance
p adc_distance
p aebcd_distance
p aed_distance

p trips_number_c_to_c
p a_to_c_4stops

p shortest_route_a_to_c
p shortest_route_b_to_b
p routes_less30_num_c_to_c
