
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


def find_small_folders(tree, path):
    total_size = 0
    folder = deep_get(tree, path)
    small_folders = []
    for name, value in folder.items():
        if type(value) is int:
            total_size += value
        else:
            sub_total_size, sub_small_folders = find_small_folders(
                tree, [*path, name])
            small_folders.extend(sub_small_folders)
            total_size += sub_total_size
    if total_size <= 100000:
        small_folders.append(total_size)
    return total_size, small_folders


tree = scan_file_tree()
_, small_folders = find_small_folders(tree, ['/'])
print(sum(small_folders))
