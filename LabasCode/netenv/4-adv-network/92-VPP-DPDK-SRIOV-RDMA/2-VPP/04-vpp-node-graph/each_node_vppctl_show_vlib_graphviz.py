import sys
import re
import os
import subprocess
from pathlib import Path

def get_all_nodes(dot_file):
    with open(dot_file, 'r') as f:
        content = f.read()
    nodes = list(set(re.findall(r'"([^"]+)"', content)))
    return nodes

def sanitize_graph_name(name):
    return re.sub(r'[^a-zA-Z0-9_]', '_', name)

def extract_node_subgraph(dot_file, target_node, output_dir):
    with open(dot_file, 'r') as f:
        lines = f.readlines()

    edges = []
    nodes_involved = set()
    for line in lines:
        if "->" in line:
            src, dst = line.strip().split("->")
            src = src.strip().strip('"')
            dst = dst.strip().strip('"')
            if src == target_node or dst == target_node:
                edges.append((src, dst))
                nodes_involved.add(src)
                nodes_involved.add(dst)

    sanitized_graph_name = sanitize_graph_name(f"{target_node}_subgraph")
    dot_content = f'digraph "{sanitized_graph_name}" {{\n'
    dot_content += '  rankdir=LR;\n'
    dot_content += '  node [shape=box, style=filled, fontsize=10, color=lightgray, fontcolor=black, fillcolor=lightgray];\n'
    dot_content += f'  "{target_node}" [color=black, fontcolor=black, fillcolor=lightgray];\n'
    dot_content += '  edge [fontsize=8];\n'

    for src, dst in edges:
        dot_content += f'  "{src}" -> "{dst}";\n'

    dot_content += '}\n'

    sanitized_node = re.sub(r'[^\w\-_\. ]', '_', target_node)
    output_dot = output_dir / f"{sanitized_node}_subgraph.dot"
    with open(output_dot, "w") as f:
        f.write(dot_content)
    return output_dot

def generate_all_subgraphs(dot_file, output_dir="subgraphs"):
    output_dir = Path(output_dir)
    output_dir.mkdir(exist_ok=True)

    nodes = get_all_nodes(dot_file)
    for node in nodes:
        print(f"Processing node: {node}")
        try:
            dot_file_path = extract_node_subgraph(dot_file, node, output_dir)
            sanitized_node = re.sub(r'[^\w\-_\. ]', '_', node)
            png_file = output_dir / f"{sanitized_node}_subgraph.png"
            subprocess.run(["dot", "-Tpng", "-o", png_file, dot_file_path], check=True)
            print(f"Generated: {png_file}")
        except subprocess.CalledProcessError as e:
            print(f"Error processing node {node}: {e}")
        except Exception as e:
            print(f"Error processing node {node}: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("vppctl show vlib graphviz > input.dot")
        print("Usage: python generate_subgraphs.py <input.dot>")
        sys.exit(1)
    
    input_dot = sys.argv[1]
    generate_all_subgraphs(input_dot)
