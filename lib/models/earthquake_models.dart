class EarthquakeModels {
  EarthquakeModels({
      this.type, 
      this.metadata, 
      this.features, 
      this.bbox,});

  EarthquakeModels.fromJson(dynamic json) {
    type = json['type'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
    bbox = json['bbox'] != null ? json['bbox'].cast<num>() : [];
  }
  String? type;
  Metadata? metadata;
  List<Features>? features;
  List<num>? bbox;
EarthquakeModels copyWith({  String? type,
  Metadata? metadata,
  List<Features>? features,
  List<num>? bbox,
}) => EarthquakeModels(  type: type ?? this.type,
  metadata: metadata ?? this.metadata,
  features: features ?? this.features,
  bbox: bbox ?? this.bbox,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    if (features != null) {
      map['features'] = features?.map((v) => v.toJson()).toList();
    }
    map['bbox'] = bbox;
    return map;
  }

}

class Features {
  Features({
      this.type, 
      this.properties, 
      this.geometry, 
      this.id,});

  Features.fromJson(dynamic json) {
    type = json['type'];
    properties = json['properties'] != null ? Properties.fromJson(json['properties']) : null;
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    id = json['id'];
  }
  String? type;
  Properties? properties;
  Geometry? geometry;
  String? id;
Features copyWith({  String? type,
  Properties? properties,
  Geometry? geometry,
  String? id,
}) => Features(  type: type ?? this.type,
  properties: properties ?? this.properties,
  geometry: geometry ?? this.geometry,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (properties != null) {
      map['properties'] = properties?.toJson();
    }
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    map['id'] = id;
    return map;
  }

}

class Geometry {
  Geometry({
      this.type, 
      this.coordinates,});

  Geometry.fromJson(dynamic json) {
    type = json['type'];
    coordinates = json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }
  String? type;
  List<num>? coordinates;
Geometry copyWith({  String? type,
  List<num>? coordinates,
}) => Geometry(  type: type ?? this.type,
  coordinates: coordinates ?? this.coordinates,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['coordinates'] = coordinates;
    return map;
  }

}

class Properties {
  Properties({
      this.mag, 
      this.place, 
      this.time, 
      this.updated, 
      this.tz, 
      this.url, 
      this.detail, 
      this.felt, 
      this.cdi, 
      this.mmi, 
      this.alert, 
      this.status, 
      this.tsunami, 
      this.sig, 
      this.net, 
      this.code, 
      this.ids, 
      this.sources, 
      this.types, 
      this.nst, 
      this.dmin, 
      this.rms, 
      this.gap, 
      this.magType, 
      this.type, 
      this.title,});

  Properties.fromJson(dynamic json) {
    mag = json['mag'];
    place = json['place'];
    time = json['time'];
    updated = json['updated'];
    tz = json['tz'];
    url = json['url'];
    detail = json['detail'];
    felt = json['felt'];
    cdi = json['cdi'];
    mmi = json['mmi'];
    alert = json['alert'];
    status = json['status'];
    tsunami = json['tsunami'];
    sig = json['sig'];
    net = json['net'];
    code = json['code'];
    ids = json['ids'];
    sources = json['sources'];
    types = json['types'];
    nst = json['nst'];
    dmin = json['dmin'];
    rms = json['rms'];
    gap = json['gap'];
    magType = json['magType'];
    type = json['type'];
    title = json['title'];
  }
  num? mag;
  String? place;
  num? time;
  num? updated;
  dynamic tz;
  String? url;
  String? detail;
  dynamic felt;
  dynamic cdi;
  num? mmi;
  String? alert;
  String? status;
  num? tsunami;
  num? sig;
  String? net;
  String? code;
  String? ids;
  String? sources;
  String? types;
  dynamic nst;
  num? dmin;
  num? rms;
  num? gap;
  String? magType;
  String? type;
  String? title;
Properties copyWith({  num? mag,
  String? place,
  num? time,
  num? updated,
  dynamic tz,
  String? url,
  String? detail,
  dynamic felt,
  dynamic cdi,
  num? mmi,
  String? alert,
  String? status,
  num? tsunami,
  num? sig,
  String? net,
  String? code,
  String? ids,
  String? sources,
  String? types,
  dynamic nst,
  num? dmin,
  num? rms,
  num? gap,
  String? magType,
  String? type,
  String? title,
}) => Properties(  mag: mag ?? this.mag,
  place: place ?? this.place,
  time: time ?? this.time,
  updated: updated ?? this.updated,
  tz: tz ?? this.tz,
  url: url ?? this.url,
  detail: detail ?? this.detail,
  felt: felt ?? this.felt,
  cdi: cdi ?? this.cdi,
  mmi: mmi ?? this.mmi,
  alert: alert ?? this.alert,
  status: status ?? this.status,
  tsunami: tsunami ?? this.tsunami,
  sig: sig ?? this.sig,
  net: net ?? this.net,
  code: code ?? this.code,
  ids: ids ?? this.ids,
  sources: sources ?? this.sources,
  types: types ?? this.types,
  nst: nst ?? this.nst,
  dmin: dmin ?? this.dmin,
  rms: rms ?? this.rms,
  gap: gap ?? this.gap,
  magType: magType ?? this.magType,
  type: type ?? this.type,
  title: title ?? this.title,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mag'] = mag;
    map['place'] = place;
    map['time'] = time;
    map['updated'] = updated;
    map['tz'] = tz;
    map['url'] = url;
    map['detail'] = detail;
    map['felt'] = felt;
    map['cdi'] = cdi;
    map['mmi'] = mmi;
    map['alert'] = alert;
    map['status'] = status;
    map['tsunami'] = tsunami;
    map['sig'] = sig;
    map['net'] = net;
    map['code'] = code;
    map['ids'] = ids;
    map['sources'] = sources;
    map['types'] = types;
    map['nst'] = nst;
    map['dmin'] = dmin;
    map['rms'] = rms;
    map['gap'] = gap;
    map['magType'] = magType;
    map['type'] = type;
    map['title'] = title;
    return map;
  }

}

class Metadata {
  Metadata({
      this.generated, 
      this.url, 
      this.title, 
      this.status, 
      this.api, 
      this.count,});

  Metadata.fromJson(dynamic json) {
    generated = json['generated'];
    url = json['url'];
    title = json['title'];
    status = json['status'];
    api = json['api'];
    count = json['count'];
  }
  num? generated;
  String? url;
  String? title;
  num? status;
  String? api;
  num? count;
Metadata copyWith({  num? generated,
  String? url,
  String? title,
  num? status,
  String? api,
  num? count,
}) => Metadata(  generated: generated ?? this.generated,
  url: url ?? this.url,
  title: title ?? this.title,
  status: status ?? this.status,
  api: api ?? this.api,
  count: count ?? this.count,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['generated'] = generated;
    map['url'] = url;
    map['title'] = title;
    map['status'] = status;
    map['api'] = api;
    map['count'] = count;
    return map;
  }

}