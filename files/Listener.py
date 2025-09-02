class Listener:
    ROBOT_LISTENER_API_VERSION = 3
    def __init__(self):
        self.total_tests = 0
        self.runned_tests = 0

    def start_test(self, data, result):
        self.runned_tests += 1
        print(f'[{self.runned_tests}/{self.total_tests}]')

    def end_test(self, data, result):
        print(f'\nTest started:\t{result.starttime}')
        print(f'Test ended:\t{result.endtime}')

    def start_suite(self, data, result):
        def _get_total_tests(suites):
            total_tests = 0
            for suite in suites:
                list_suites = suite.get('suites', None)
                if list_suites:
                    total_tests += _get_total_tests(list_suites)
                else:
                    total_tests += len(suite['tests'])
            return total_tests
            
        if data.name == 'Tests':
            self.total_tests = _get_total_tests(data.to_dict()['suites'])