from __future__ import division
from decimal import Decimal
import numpy as np
import cv2
import common
import sys
import datetime
#import multiprocessing
#from threading import Thread

mthreshold = 5
ratio = 0.75
tdelta = 0

FLANN_INDEX_KDTREE = 1  
FLANN_INDEX_LSH    = 6
detector = cv2.BRISK_create()
norm = cv2.NORM_HAMMING
flann_params= dict(algorithm = FLANN_INDEX_LSH, table_number = 6, key_size = 12, multi_probe_level = 1)
matcher = cv2.FlannBasedMatcher(flann_params, {})

img1flnm = sys.argv[1]
img2flnm = sys.argv[2]
tmstart = datetime.datetime.now()

#read image to be found
try:
	img1 = cv2.imread(img1flnm, 0)	
	kp1, desc1 = detector.detectAndCompute(img1, None)
except:
	kp1 = [] 

#read image to be analyzed
try:
	img2 = cv2.imread(img2flnm, 0)	
	kp2, desc2 = detector.detectAndCompute(img2, None)
except:
	kp2 = []

#print "LEN KP1 = " + str(len(kp1))
#print "LEN KP2 = " + str(len(kp2))
	
if (len(kp1) == 0 or len(kp2) == 0):
	print '{"found":%s, "match":%s, "features":%s, "inliers":"%s", "elapsed time":"%s secs"}' % ("false","0","null","null","0")
	exit()

#try:
if 1 == 1:
	mkp1 = []
	maxmatch = 0
	maxnfeats = 0
	maxinlier = 0
	maxftmtch = 0	
	found = "false"
	client_id = "null"
	client_name = "null"
	
	nfeats = len(kp1)
	raw_matches = matcher.knnMatch(desc1, trainDescriptors = desc2, k = 2) #2
	mkp1,mkp2 = [], []
	
	for m in raw_matches:
		if len(m) == 2 and m[0].distance < m[1].distance * ratio:
			m = m[0]
			mkp1.append( kp1[m.queryIdx] )
			mkp2.append( kp2[m.trainIdx] )
			
		p1 = np.float32([kp.pt for kp in mkp1])
		p2 = np.float32([kp.pt for kp in mkp2])
		kp_pairs = zip(mkp1, mkp2)

		#Matching
		#print len(p1)
		if len(p1) >= 4:
			H, status = cv2.findHomography(p1, p2, cv2.RANSAC, 5.0)
			inliers = np.sum(status)
			matched = len(status)
			pmatch = round((inliers*100)/nfeats,2)
			#print "inliers = %s, match = %s" %(inliers,pmatch)
			if pmatch >= maxmatch:
				found = "true"
				maxmatch = pmatch
				maxnfeats = nfeats
				maxinlier = inliers
				maxftmtch = matched

		#return [found,maxmatch,client_id,client_name,maxnfeats,maxinlier,maxftmtch]
		results = [found,maxmatch,maxnfeats,maxinlier,maxftmtch]

	tmdone = datetime.datetime.now()
	tdelta = tmdone - tmstart
	tmdiff = divmod(tdelta.days * 86400 + tdelta.seconds, 60)
	
	if float(results[1]) >= mthreshold: 
		print '{"found":%s, "match":%s, "features":%s, "inliers":"%s", "elapsed time":"%s secs"}' % (results[0],results[1],results[2],results[3],tdelta.seconds)		
	else:
		print '{"found":%s, "match":%s, "features":%s, "inliers":"%s", "elapsed time":"%s secs"}' % ("false","0","null","null",tdelta.seconds)		
#except:
else:
	print '{"found":%s, "match":%s, "features":%s, "inliers":"%s", "elapsed time":"%s secs"}' % ("false","0","null","null",tdelta.seconds)
