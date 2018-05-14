from IBMQuantumExperience import IBMQuantumExperience
from qiskit import QuantumProgram
import QConfig

api = IBMQuantumExperience(QConfig.APItoken, QConfig.config)

def set_zero(qc, qr):
    pass

def set_one(qc, qr):
    qc.x(qr[0])

def set_plus(qc, qr):
    qc.h(qr[0])

def set_minus(qc, qr):
    qc.h(qr[0])
    qc.z(qr[0])

def cnot_experiment(num, init):
    qp = QuantumProgram()

    qp.set_api(QConfig.APItoken, QConfig.config['url'])

    qr = qp.create_quantum_register('qr', num)
    cr = qp.create_classical_register('qc', num)
    qc = qp.create_circuit('CNOT', [qr], [cr])

    init(qc, qr)

    for i in range(num - 1):
        qc.cx(qr[i], qr[i + 1])

    for i in range(num):
        qc.measure(qr[i], cr[i])

    return qp


