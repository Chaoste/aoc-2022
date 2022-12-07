MAX_STORAGE = 70000000
FREE_STORAGE = 30000000


def deep_set(tree, path, value):
    current_level = tree
    for dir in path[:-1]:
        current_level = current_level[dir]
    if path[-1] not in current_level:
        current_level[path[-1]] = value
    return current_level


def deep_get(tree, path):
    current_level = tree
    for dir in path:
        current_level = current_level[dir]
    return current_level


def scan_file_tree():
    pwd = ['/']
    tree = {'/': {}}

    with open('input.txt') as f:
        for i, _line in enumerate(f.readlines()):
            line = _line.strip()
            if i == 0:
                continue
            elif line == '$ cd ..':
                pwd = pwd[:-1]
            elif line[:4] == '$ cd':
                target_dir = line[5:]
                pwd.append(target_dir)
                deep_set(tree, pwd, {})
            elif line == '$ ls':
                continue
            elif line[:3] == 'dir':
                dir_name = line[4:]
                deep_set(tree, [*pwd, dir_name], {})
            else:
                [size, name] = line.split(' ')
                deep_set(tree, [*pwd, name], int(size))
    return tree


def get_folder_size(tree, path):
    total_size = 0
    folder = deep_get(tree, path)
    for name, value in folder.items():
        if type(value) is int:
            total_size += value
        else:
            sub_total_size = get_folder_size(tree, [*path, name])
            total_size += sub_total_size
    return total_size


def find_deletable_folder(tree, path, lower_size_limit):
    total_size = 0
    folder = deep_get(tree, path)
    candidate_size = MAX_STORAGE
    for name, value in folder.items():
        if type(value) is int:
            total_size += value
        else:
            sub_total_size, sub_candidate_size = find_deletable_folder(
                tree, [*path, name], lower_size_limit)
            candidate_size = min(candidate_size, sub_candidate_size)
            total_size += sub_total_size
    if total_size >= lower_size_limit:
        candidate_size = min(candidate_size, total_size)
    return total_size, candidate_size


tree = scan_file_tree()
total_size = get_folder_size(tree, ['/'])
overcharged = total_size - (MAX_STORAGE - FREE_STORAGE)
_, candidate_size = find_deletable_folder(tree, ['/'], overcharged)
print(overcharged, candidate_size)
