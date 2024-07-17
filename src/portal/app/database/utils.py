from pynamodb.pagination import ResultIterator


def return_pagination_result(iter: ResultIterator) -> list[dict]:
    result = []
    while True:
        try:
            next_item = iter.next()
            result.append(next_item.attribute_values)
        except StopIteration:
            break
    return result
