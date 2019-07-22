'use strict';

exports.handler = (event, context, callback) => {
	// Drop any records that match the "default" action (ie all the "normal" traffic that isn't matching a rule)
	const output = event.records.map((record) => {
		const entry = (new Buffer(record.data, 'base64')).toString('utf8');
		if (!entry.match(/Default_Action/g)) {
			return {
				recordId: record.recordId,
				result: 'Ok',
				data: record.data,
			};
		}
		return {
			recordId: record.recordId,
			result: 'Dropped',
			data: record.data,
		};
	});
	console.log(`filtered ${event.records.length - output.length} records matching default action from total of ${event.records.length}.`);
	callback(null, { records: output });
};
