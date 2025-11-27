import math
from scipy.integrate import quad

OMr = 0.0001
OMm = 0.3
OMv = 0.7


def lambda_cdm(x):
    return 1 / (math.sqrt(OMr * (1 + x) ** 4 + OMm * (1 + x) ** 3 + OMv))


def calculate_distance(z):
    if z >= 0:
        I = quad(lambda_cdm, 0, z, args=())
        return I[0]
    return 0


def to_radians(angle):
    return angle * math.pi / 180


def changeCoordsSpericalX(r, ra_longitude, dec_latitude):
    return r * math.cos(to_radians(ra_longitude)) * math.cos(to_radians(dec_latitude))


def changeCoordsSpericalY(r, ra_longitude, dec_latitude):
    return r * math.sin(to_radians(ra_longitude)) * math.cos(to_radians(dec_latitude))


def changeCoordsSpericalZ(r, ra_longitude, dec_latitude):
    return r * math.sin(to_radians(dec_latitude))


def parseRANumeric(hour, min=0, sec=0):
    number = hour * 360 / 24
    number = number + (360 / 24) * (min / 60)
    number = number + (360 / 24) * (sec / 3600)
    return (number)


def parseDECNumeric(degree, min=0, sec=0):
    suma = 1
    if degree < 0:
        suma = -1
        return (suma) * sec / 3600 + (suma) * min / 60 + degree
