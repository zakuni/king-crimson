var request = require('supertest'),
    app = require('../king-crimson'),
    req = request(app);

describe('GET /', function() {
  it('should response with 200', function(done) {
    req.get('/')
      .expect(200)
      .end(function(err, res) {
        if (err) throw err;
        done();
      });
  });
});
