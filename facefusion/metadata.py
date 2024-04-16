METADATA =\
{
	'name': 'FaceBlend',
	'description': 'FaceBlend Studio is a revolutionary Windows application designed for facial manipulation in videos',
	'version': '1.0.1',
	'license': 'MIT',
	'author': 'Henry Ruhs',
	'url': 'https://faceblend.io'
}


def get(key : str) -> str:
	return METADATA[key]
