from operator import itemgetter


def sort_and_output(title: str, data: list, index: int = 2):
    output = f"\n\n{title}\n"
    sorted_data = sorted(data, key=lambda k: float(k[index]["value"]), reverse=True)
    for item in sorted_data:
        agency = item[0]["formattedValue"]
        value = item[index]["formattedValue"]
        output += f"{agency} : {value}\n"
    return sorted_data, output